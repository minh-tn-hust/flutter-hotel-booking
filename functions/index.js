/* eslint-disable */
"use strict";
const functions = require("firebase-functions");

const admin = require("firebase-admin");
// eslint-disable-next-line max-len
const stripe = require("stripe")("sk_test_51J0pA5COvGgqIugFfrxjtfXiQfNQCSc4Tv6HTxFjKwV0liqE1KoS6FcfX9F0ob5SHkktfYa8weqMvdb84lhY9uUA00hKeYJpLm");
admin.initializeApp();
const db = admin.firestore();
const nodemailer = require("nodemailer");

// triger -> tạo user info mỗi lần ngườ dùng tạo một account với user
exports.newUserInfo = functions.auth.user().onCreate(async (user) => {
  await admin.firestore().collection("userInfo").doc(user.uid).set(
      {
        customerID: "new",
        email: user.email,
        firstName: "No information",
        lastName: "No information",
        country: "No information",
        mobile: "No information",
        postCode: "No information",
        cards: [],
        baned: null,
      },
  );
},
);


// lấy clientSecret cung cấp cho người dùng
exports.getClientSecret = functions.https.onRequest(async (req, res) => {
  const amount = req.query.amount;
  const destination = req.query.destination;
  const userID = req.query.userID;
  const paymentMethodID = req.query.pmID; // lấy trước tiếp từ người dùng chọn luôn
  const userInfo = (await db.collection("userInfo").doc(userID).get());
  console.log("++++++++++++++++++++++++++");
  console.log("amount " + amount);
  console.log("userId " + userID);
  console.log("destination " + destination);
  console.log("customerId " + userInfo.data().customerID);
  console.log("paymentMethodId " + paymentMethodID);
  console.log("++++++++++++++++++++++++++");
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      payment_method_types: ["card"],
      amount: amount,
      currency: "usd",
      customer: userInfo.data().customerID, // cung cấp thông tin người dùng
      payment_method: paymentMethodID,
      receipt_email: userInfo.data().email,
      // on_behalf_of: destination,
      transfer_data: { // đối với hôst, đây là địa chỉ chuyển tiền tới
        destination: destination,
      },
    });
    const clientSecret = paymentIntent.client_secret;
    res.json({result: clientSecret, paymentMethod: paymentMethodID}); // trả về clientSecret với cái id của card -> người đã thêm từ trước
  } catch (e) {
    res.json({error: e.message});
  }
});

// tạo ra link để host có thể xem được lượng tiền của mình di chuyển như nào
exports.goToDashBoard = functions.https.onRequest(async (req, res) => {
  const id = req.query.id;
  // const link = await stripe.accountLinks.create({
  //   account: id,
  //   refresh_url: "https://example.com/reauth",
  //   return_url: "https://example.com/return",
  //   type: "account_onboarding",
  // });
  const link = await stripe.accounts.createLoginLink(id);
  res.json({link: link["url"]});
});


// tạo payment accout cho host để có thể nhận được tiền về
exports.createPaymentAccount = functions.https.onRequest(async (req, res) => {
  const userId = req.query.userId;
  const account = await stripe.accounts.create({
    type: "express",
  });

  await db.collection("Host").doc(userId).set({"accountId": account.id});

  const accountLink = await stripe.accountLinks.create({
    account: account.id,
    refresh_url: "https://example.com/reauth",
    return_url: "https://example.com/return",
    type: "account_onboarding",
  });
  res.json({accountLink: accountLink, accoutId: account});
});

// sau mỗi lần thanh toán thành công, hàm này dùng để câp nhật thông tin mà liên quan tới thanh toán thành công đấy
exports.updatePayment = functions.https.onRequest(async (req, res) => {
  const clientSecret = req.query.clientSecret;
  const hotelId = req.query.hotelID;
  const roomId = req.query.roomId;
  console.log("hotelID = " + hotelId);
  console.log("client Secret = " + clientSecret);
  try {
    const paymentIntent = await stripe.paymentIntents.retrieve(
        clientSecret,
    );
    var docRef = await db.collection("paymentIntent").add({
      amount: paymentIntent.amount,
      customerID: paymentIntent.charges.data[0].customer,
      create: paymentIntent.charges.data[0].created,
      paymentIntentId: paymentIntent.id,
      hotelId: hotelId,
      roomId: roomId,
    });
    console.log(docRef.id);
    res.json({
      status: "Done",
      id: docRef.id,
    });
  } catch (error) {
    console.log(error.message);
  }
});

// tạo refund để hủy yêu cầu đặt phòng
exports.createRefund = functions.https.onRequest(async (req, res) => {
  const docId = req.query.docId;
  const paymentIntentId = req.query.paymentIntentId;
  const paymentIntentRef = await db.collection("paymentIntent").doc(docId).get();
  const bookDate = (Date.now()/1000 - paymentIntentRef.data().create)/60/60/24;
  console.log("bookDate");
  console.log(bookDate);
  console.log("Booking Date = " + bookDate);
  const amount = paymentIntentRef.data().amount;
  const fully = (bookDate >= 4)?true:false;
  console.log("Amount = " + Math.round(amount*0.7));
  console.log("Is >= 4 days?: " + fully);
  try {
    if (!fully) {
      console.log("Fully refund");
      await stripe.refunds.create({
        reason: "requested_by_customer",
        payment_intent: paymentIntentId,
        reverse_transfer: true,
      });
    } else {
      console.log("70% Refund");
      await stripe.refunds.create({
        amount: Math.round(amount*0.7),
        reason: "requested_by_customer",
        payment_intent: paymentIntentId,
        reverse_transfer: true,
      });
    }
    // update lại paymentIntent ở đây -> cần hotelId + docId
    await db.collection("paymentIntent").doc(docId).update({
      status: "cancel",
    });
    res.json({status: "Done"});
  } catch (e) {
    console.log(e.raw.message);
    res.json({status: "error", error: e.raw.message});
  }
});

// kiểm tra xem phòng hiện tại đã có người book hay chưa
exports.checkColusion = functions.https.onRequest(async (req, res) => {
  const roomId = req.query.roomId;
  const beginDate = req.query.beginDate;
  const endDate = req.query.endDate;
  console.log("begin Date: " + beginDate);
  console.log("endDate: " + endDate);
  const rooms = await db.collection("paymentIntent").where("roomId", "==", roomId).get();
  // rooms.forEach((e) => console.log(e.data()));
  var colusion = 0;
  for (var date of (await rooms).docs) {
    var begin = date.data().beginDate;
    var end = date.data().endDate;
    console.log("=============ROOM INFOR===============");
    console.log("begin " + begin + " end " + end);
    var roomAmount = date.data().roomAmount;
    console.log("roomAmount " + roomAmount);
    console.log(!(endDate <= begin || beginDate >= end));
    if (!(endDate <= begin || beginDate >= end) && roomAmount != undefined && endDate >= Math.floor(Date.now() / 1000) && date.data().status == "pay") {
      console.log(colusion);
      colusion+= roomAmount;
    // eslint-disable-next-line no-unused-vars
    } else colusion+=0;
  }
  res.json({colusion: colusion});
});
// check thẻ cho người dùng 
exports.checkCard = functions.https.onRequest(async (req, res) => {
  const cardNumber = req.query.cardNumber;
  const holder = req.query.holder;
  const expMonth = req.query.expMonth;
  const expYear = req.query.expYear;
  const cvc = req.query.cvc;
  try {
    // tạo token từ thông tin card cung cấp
    const token = await stripe.tokens.create({
      card: {
        number: cardNumber,
        exp_month: expMonth,
        exp_year: expYear,
        name: holder,
        cvc: cvc,
      },
    });
    res.json({status: "Done"});
  } catch (error) {
    res.json({status: "Error", error: error.raw.message});
  }
});

// tạo cảrd dành cho người dùng lần thứ nhất
exports.cretateCardForUser = functions.https.onRequest(async (req, res) => {
  const cardNumber = req.query.cardNumber;
  const holder = req.query.holder;
  const expMonth = req.query.expMonth;
  const expYear = req.query.expYear;
  const cvc = req.query.cvc;
  const uid = req.query.uid;
  console.log(cardNumber);
  console.log(holder);
  console.log(expMonth);
  console.log(expYear);
  console.log(cvc);
  console.log(uid);
  try {
  // lấy thông tin card từ id của người dùng
    const getUserInfo = await db.collection("userInfo").doc(uid).get();
    const cards = getUserInfo.data().cards;
    // tạo token từ thông tin card cung cấp
    const token = await stripe.tokens.create({
      card: {
        number: cardNumber,
        exp_month: expMonth,
        exp_year: expYear,
        name: holder,
        cvc: cvc,
      },
    });
    await stripe.customers.createSource(
        getUserInfo.data().customerID,
        {source: token.id},
    );
    // so sánh fingerprint, nếu trùng thì res -> "stripeError: duplicate"
    var check = true;
    for (var card of cards) {
      if (card.fingerPrint == token.card.fingerprint) {
        check = false;
        break;
      }
    }
    if (check) {
      await stripe.paymentMethods.attach(
          token.card.id,
          {customer: getUserInfo.data().customerID},
      );
      cards.unshift({last4: token.card.last4, brand: token.card.brand, id: token.card.id, fingerPrint: token.card.fingerprint});
      await db.collection("userInfo").doc(uid).update({cards: cards});
      console.log(cards);
      // Thêm vào firebase

      res.json({status: "Done", id: cards[0].id});
    } else {
      res.json({status: "Error", message: "Duplicate Card"});
    }
  } catch (error) {
    res.json({status: "Error", error: error.raw.message});
  }
  // nếu như không trùng thì thực hiện attach card vào cho người dùng rồi trả về "status: sussceed"
});
exports.createNewUserWithCard = functions.https.onRequest(async (req, res) => {
  const cardNumber = req.query.cardNumber;
  const holder = req.query.holder;
  const expMonth = req.query.expMonth;
  const expYear = req.query.expYear;
  const cvc = req.query.cvc;
  const uid = req.query.uid;
  console.log(cardNumber);
  console.log(holder);
  console.log(expMonth);
  console.log(expYear);
  console.log(cvc);
  console.log(uid);
  try {
    // lấy thông tin về số lượng card hiện tại của người dùng
    var cards = [];
    // Đầu tiên là create token
    const token = await stripe.tokens.create({
      card: {
        number: cardNumber,
        exp_month: expMonth,
        exp_year: expYear,
        name: holder,
        cvc: cvc,
      },
    });
    console.log("========Token===========");
    console.log(token);
    // Tiếp theo là thêm token vào người dùng -> thêm phương thức thanh toán
    const createCustomer = await stripe.customers.create({
      description: "This is customer <-> user",
      source: token.id,
    });
    cards.push({last4: token.card.last4, brand: token.card.brand, id: token.card.id, fingerPrint: token.card.fingerprint});
    console.log(cards);
    // Thêm vào firebase
    await db.collection("userInfo").doc(uid).update({cards: cards, customerID: createCustomer.id});
    res.json({status: "Done", id: cards[0].id});
  } catch (error) {
    console.log("=============Error=============");
    res.json({status: "Error",error: error.message});
  }
});

// tạo card va thêm thông tin card vào hồ sơ của người dùng (đối với người dùng lần thứ 2 trở đi )
exports.createCard = functions.https.onRequest(async (req, res) => {
  const cardNumber = req.query.cardNumber;
  const holder = req.query.holder;
  const expMonth = req.query.expMonth;
  const expYear = req.query.expYear;
  const cvc = req.query.cvc;
  const uid = req.query.uid;
  console.log(cardNumber);
  console.log(holder);
  console.log(expMonth);
  console.log(expYear);
  console.log(cvc);
  console.log(uid);
  try {
    // lấy thông tin về số lượng card hiện tại của người dùng
    const userInfo = await db.collection("userInfo").doc(uid).get();
    var cards = userInfo.data().cards;
    if (cards == undefined) {
      cards = [];
    }
    // Đầu tiên là create token
    const token = await stripe.tokens.create({
      card: {
        number: cardNumber,
        exp_month: expMonth,
        exp_year: expYear,
        name: holder,
        cvc: cvc,
      },
    });
    // Tiếp theo là thêm token vào người dùng -> thêm phương thức thanh toán
    const attach = await stripe.customers.createSource(
        userInfo.data().customerID,
        {source: token.id},
    );
    cards.push({last4: attach.last4, brand: attach.brand, id: attach.id, fingerPrint: token.card.fingerprint});
    console.log(cards);
    // Thêm vào firebase
    await db.collection("userInfo").doc(uid).update({cards: cards});

    res.json({status: "Done", id: attach.id});
  } catch (error) {
    res.json({error: error.message});
  }
});

exports.loadRecommendHotel = functions.https.onRequest(async (req, res) =>{
  var hotHotel = new Map();
  await db.collection("paymentIntent").get().then((docCumentSnapshot) => {
    docCumentSnapshot.forEach((e) => {
      var hotelId = e.data()["hotelId"];
      console.log("Hotel Id " + hotelId);
      if (hotHotel.has(hotelId)) {
        var temp = hotHotel.get(hotelId)+1;
        console.log(temp);
        hotHotel.set(hotelId, temp);
      } else {
        hotHotel.set(hotelId, 1);
      }
    });
  });
  console.log(hotHotel);
  var mapAsc = new Map([...hotHotel.entries()].sort());
  res.json({id: Array.from(mapAsc.keys())});
});


exports.helloPubSub = async (event, context) => {
  if (event.data != undefined) {
    console.log("Check exp room");
    try {
      await db.collection("paymentIntent").where("endDate", "<", Date.now()/1000 - 6*24*60*60)
          .get().then((querySnapshot) => {
            querySnapshot.forEach((docRef) => {
              if (docRef.data().status != "cancel") {
                docRef.ref.update({"status": "checkout"});
              }
            });
          });
    // eslint-disable-next-line guard-for-in
    } catch (e) {
      console.log(e);
    }
  }
};


// random mật khẩu dành cho người được add vào
// eslint-disable-next-line require-jsdoc
function makeId(length) {
  var result = "";
  var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  var charactersLength = characters.length;
  for ( var i = 0; i < length; i++ ) {
    result += characters.charAt(Math.floor(Math.random() *
charactersLength));
  }
  return result;
}

exports.createAdminAccount = functions.https.onRequest(async (req, res)=>{
  const email = req.query.email;
  const password = makeId(10);
  console.log(password);
  admin.auth().createUser({
    email: email,
    password: password,
    displayName: "Admin",
  }).then((userRecord) => {
    console.log("Create successful with uid = ", userRecord.uid);
  }).catch((error)=> {
    console.log("Has an error: ", error);
  });
  res.json({password: password});
});

exports.getHostAccount = functions.https.onRequest(async (req, res) => {
  const email = req.query.email;
  console.log("Emal + :"+email);
  var list = [];
  var listHostId = await listAllHosts(undefined, email);
  console.log(listHostId);
  await db.collection("userInfo").get().then((querySnapshot) => {
    querySnapshot.docs.forEach((element) => {
      console.log(element.id + "Mobile + :" + element.data()["mobile"]);
      console.log(listHostId.includes(element.id));
      if (listHostId.includes(element.id)) {
        if (element.data()["mobile"].includes(email)||element.data()["firstName"].includes(email)||element.data()["email"].includes(email) || email == "") {
          list.push({
            uid: element.id,
            email: element.data()["email"],
          });
        }
      }
    });
  });

  console.log(list);
  for (const value of list) {
    value["hotels"] = [];
    await db.collection("hotelWithInfo").where("hostID", "==", value.uid).get().then((querySnapshot) =>{
      querySnapshot.docs.forEach((element) => {
        value["hotels"].push(element.id);
      });
    });

    await db.collection("userInfo").doc(value.uid).get().then((docSnapshot) =>{
      console.log(docSnapshot.data());
      value["CustomerInfo"] = docSnapshot.data();
    });
  }
  console.log(list);
  res.json({data: list});
});

exports.getUserAccount = functions.https.onRequest(async (req, res) => {
  const email = req.query.email;
  console.log("Emal + :"+email);
  var list = [];
  var listUserId = await listAllUser(undefined, email);
  console.log(listUserId);
  await db.collection("userInfo").get().then((querySnapshot) => {
    querySnapshot.docs.forEach((element) => {
      if (listUserId.includes(element.id)) {
        if (element.data()["mobile"].includes(email)||element.data()["firstName"].includes(email)||element.data()["email"].includes(email) || email == "") {
          list.push({
            uid: element.id,
            email: element.data()["email"],
          });
        }
      }
    });
  });

  console.log(list);
  for (const value of list) {
    value["Hotel"] = [];
    await db.collection("userInfo").doc(value.uid).get().then((docSnapshot) =>{
      console.log(docSnapshot.data());
      value["CustomerInfo"] = docSnapshot.data();
    });
  }
  console.log(list);
  res.json({data: list});
});

const listAllUser = async (nextPageToken, email) => {
  // List batch of users, 1000 at a time.
  var list = [];
  await admin
      .auth()
      .listUsers(1000, nextPageToken)
      .then((listUsersResult) => {
        listUsersResult.users.forEach((userRecord) => {
          if (userRecord.displayName.includes("User")) {
            list.push(userRecord.uid);
          }
        });
        if (listUsersResult.pageToken) {
        // List next batch of users.
          listAllHosts(listUsersResult.pageToken);
        }
      })
      .catch((error) => {
        console.log("Error listing users:", error);
      });
  return list;
};


const listAllHosts = async (nextPageToken, email) => {
  // List batch of users, 1000 at a time.
  var list = [];
  await admin
      .auth()
      .listUsers(1000, nextPageToken)
      .then((listUsersResult) => {
        listUsersResult.users.forEach((userRecord) => {
          if (userRecord.displayName.includes("Host")) {
            list.push(userRecord.uid);
          }
        });

        if (listUsersResult.pageToken) {
        // List next batch of users.
          listAllHosts(listUsersResult.pageToken);
        }
      })
      .catch((error) => {
        console.log("Error listing users:", error);
      });
  return list;
};

exports.getPaymentIntent = functions.https.onRequest(async (req, res) => {
  const pay = await db.collection("hotelNotifi").doc("BPFzSx6vObITVgALBjI4").get();
  res.json({Notifi: pay.data()});
});
exports.retrieveConnectedAccount = functions.https.onRequest(async (req, res) => {
  const accoutId = req.query.id;
  const account = await stripe.accounts.retrieve(accoutId);
  res.json({check: account.details_submitted});
});

exports.banUser = functions.https.onRequest(async (req, res) => {
  const uid = req.query.uid;
  const role = req.query.role;
  admin
      .auth()
      .updateUser(uid, {
        displayName: role + "Baned",
      })
      .then(async (userRecord) => {
        console.log("Successfully baned user", userRecord.toJSON());
        await db.collection("userInfo").doc(uid).update({baned: true});
        res.json({status: "Done"});
      })
      .catch((error) => {
        console.log("Error updating user:", error);
        res.json({status: "Error", message: error});
      });
});

exports.unbanUser = functions.https.onRequest(async (req, res) => {
  const uid = req.query.uid;
  const role = req.query.role;
  console.log(uid);
  console.log(role);
  admin
      .auth()
      .updateUser(uid, {
        displayName: role,
      })
      .then(async (userRecord) => {
        console.log("Successfully unbaned user", userRecord.toJSON());
        await db.collection("userInfo").doc(uid).update({baned: null});
        res.json({status: "Done"});
      })
      .catch((error) => {
        console.log("Error updating user:", error);
      });
});


exports.changePassword = functions.https.onRequest(async (req, res) => {
  const email = req.query.email;
  var uid = "";
  await admin.auth().getUserByEmail(email).then((userRecord) => {
    uid = userRecord.uid;
  });
  const newPassword = makeId(12);
  await admin.auth().updateUser(uid, {
    password: newPassword,
  }).then(function(userRecord) {
    // See the UserRecord reference doc for the contents of userRecord.
    console.log("Successfully updated user", userRecord.toJSON());
  })
      .catch(function(error) {
        console.log("Error updating user:", error);
      });
  var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "hotelbookappvudinhphu@gmail.com",
      pass: "05062001minh",
    },
  });
  var handlebars = require("handlebars");
  var fs = require("fs");
  var mailOptions = {
    from: "hotelbookappvudinhphu@gmail.com",
    to: email,
    subject: "Reset Password from VuDinhPhu",
    html: {
      path: "C:/Users/minht/Desktop/flutter_project-main/functions/reset_password.html",
    },
  };
  console.log(__dirname + "\\reset_password.html");
  fs.readFile(__dirname + "\\reset_password.html", (error, fileData) => {
    var template = handlebars.compile(fileData.toString());
    var replacements = {
      newPassword: newPassword,
    };
    var htmlToSend = template(replacements);
    var mailOptions = {
      from: "hotelbookappvudinhphu@gmail.com",
      to: email,
      subject: "Reset Password from VuDinhPhu",
      html: htmlToSend,
    };
    transporter.sendMail(mailOptions, function(error, info) {
      if (error) {
        res.json({"status": "error", "error": "Something wrong in our process"});
        console.log(error);
      } else {
        res.json({status: info.response});
        console.log("Email sent: " + info.response);
      }
    });
  });
  res.json({status: "Done"});
});

exports.updateDatabase = functions.https.onRequest(async (req, res) => {
  const uid = req.query.uid;
  await db.collection("hotelWithInfo").get().then((snapShot) => {
    snapShot.forEach((docSnapshot) => {
      docSnapshot.ref.update({hostID: uid});
    });
  });
  res.json("Done");
});
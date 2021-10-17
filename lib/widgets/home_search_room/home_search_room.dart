import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/home_search_room/pick_date.dart';
import 'package:hotel_booking_app/widgets/home_search_room/pick_location/pick_location.dart';
import 'package:provider/provider.dart';

import 'custom_dropdown_button.dart';

class HomeSearchRoom extends StatefulWidget {
  final Function() callBack;
  final SearchInfoModel searchInfo;
  const HomeSearchRoom({
    Key? key,
    required this.searchInfo,
    required this.callBack,
  }) : super(key: key);

  @override
  _HomeSearchRoomState createState() => _HomeSearchRoomState();
}

class _HomeSearchRoomState extends State<HomeSearchRoom> {
  SearchInfoModel? searchInfo;
  @override
  void initState() {
    searchInfo = widget.searchInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 35,
        left: 16,
        right: 16,
      ),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Color(0xFF393939),
      ),
      child: Column(
        children: [
          Row(
            children: [
              PickLocation(
                // cho phép người dùng có thể tìm kiếm được thông tin về vị trí
                location: widget.searchInfo.location,
                setLocation: (Location pickedItem) {
                  setState(() {
                    searchInfo!.location = pickedItem;
                    Provider.of<SearchModel>(context, listen: false)
                        .updateLocation(pickedItem);
                  });
                },
              ),
              Spacer(),
              CustomDropdownButton(
                digit: "Guests",
                // pass function that children can call setState of its parent on that
                onChange: (number) {
                  setState(() {
                    searchInfo!.guests = (number! + 1);
                    Provider.of<SearchModel>(context, listen: false)
                        .updateGuests(number + 1);
                  });
                },
                hintText: "Guests",
                children: List.generate(10, (index) => index),
              ),
            ],
          ),
          SizedBox(
            height: 23,
          ),
          Row(
            children: [
              PickDate(
                // sử dụng để người dùng có thể pick được ngày
                beginDate: searchInfo!.beginDate,
                endDate: searchInfo!.endDate,
                onChange: (begin, end) {
                  print(begin);
                  print(end);
                  setState(() {
                    searchInfo!.beginDate = begin;
                    searchInfo!.endDate = end;
                    searchInfo!.nights = searchInfo!.endDate
                        ?.difference(searchInfo!.beginDate!)
                        .inDays;
                    Provider.of<SearchModel>(context, listen: false)
                        .updateTime(begin, end);
                    Provider.of<SearchModel>(context, listen: false)
                        .updateNight(searchInfo!.nights!);
                  });
                },
              ),
              Spacer(),
              Container(
                /// hiển thị số lượng ngày mà người ấy đã đặt
                padding: EdgeInsets.only(
                  left: 6,
                ),
                height: 50,
                width: 130,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(223, 222, 222, 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (searchInfo!.nights == null)
                        ? "Days"
                        : "${searchInfo!.nights} Days",
                    style: Constraint.Nunito(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 29,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: CustomButton(
              // nút dùng để xác nhận những gì người dùng đã tìm kiếm
              height: 70,
              onTap: () {
                if (searchInfo!.location == null ||
                    searchInfo!.guests == null ||
                    searchInfo!.beginDate == null ||
                    searchInfo!.endDate == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            CustomButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                buttonTitle: "Confirm",
                                textStyle: Constraint.Nunito(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                height: 50)
                          ],
                          title: Text(
                            "Warning",
                            style: Constraint.Nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          content: Text(
                            "Fill in the blank to search",
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        );
                      });
                } else {
                  widget.callBack();
                  Provider.of<SearchModel>(context, listen: false).toString();
                }
              },
              buttonTitle: "Search Room",
              textStyle: Constraint.Nunito(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

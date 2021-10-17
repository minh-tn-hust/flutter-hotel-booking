import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/widgets/pick_image/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddHotelImage extends StatefulWidget {
  const AddHotelImage({Key? key}) : super(key: key);

  @override
  _AddHotelImageState createState() => _AddHotelImageState();
}

class _AddHotelImageState extends State<AddHotelImage> {
  List<PickedFile>? _pickedFileList;
  final _picker = ImagePicker();
  void getImage(int index) async {
    // Hàm dùng để có thể cho phép người dùng lấy ảnh từ thư viện
    var imagefile = await _picker.getImage(source: ImageSource.gallery);
    if (imagefile != null) {
      setState(() {
        _pickedFileList![index] = imagefile;
      });
      Provider.of<HotelProvider>(context, listen: false)
          .updateImagePath(imagefile.path, index);
    }
  }

  @override
  void initState() {
    super.initState();
    var imagePath =
        Provider.of<HotelProvider>(context, listen: false).addHotel!.imagePath!;
    List<PickedFile> getFile = imagePath.map((e) => PickedFile(e)).toList();
    _pickedFileList = getFile;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PickImage(
              height: 210,
              width: 360,
              file:
                  (_pickedFileList![0].path == "") ? null : _pickedFileList![0],
              callBack: () {
                getImage(0);
              },
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                4,
                (index) => PickImage(
                  height: 100,
                  width: 180,
                  file: (_pickedFileList![index + 1].path == "")
                      ? null
                      : _pickedFileList![index + 1],
                  callBack: () {
                    getImage(index + 1);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

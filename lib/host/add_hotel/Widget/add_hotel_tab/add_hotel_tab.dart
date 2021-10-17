import 'package:flutter/material.dart';

class AddHotelTab extends StatelessWidget {
  const AddHotelTab({
    required this.callBack,
    Key? key,
  }) : super(key: key);
  final void Function() callBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      onTap: callBack,
      child: Container(
        // nút dùng để thêm khách sạn
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(
          top: 5,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        height: 80,
        child: Center(
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}

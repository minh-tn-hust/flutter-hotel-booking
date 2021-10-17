// hiển thị thông tin người dùng và edit
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:provider/provider.dart';

import '../../../../constraint.dart';

class EditableTile extends StatefulWidget {
  const EditableTile({
    required this.title,
    required this.content,
    required this.callBack,
    required this.textController,
    Key? key,
  }) : super(key: key);
  final String? title;
  final String? content;
  final void Function() callBack;
  final TextEditingController textController;

  @override
  _EditableTileState createState() => _EditableTileState();
}

class _EditableTileState extends State<EditableTile> {
  bool isEdit = false;
  FocusNode focus = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: ListTile(
          trailing: (!isEdit)
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                    focus.requestFocus();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    if (formKey.currentState!.validate())
                      setState(() {
                        Provider.of<ApplicationState>(context, listen: false)
                            .change(widget.title!, widget.textController.text);
                        isEdit = !isEdit;
                        widget.callBack();
                      });
                  },
                ),
          subtitle: TextFormField(
            focusNode: focus,
            validator: (value) {
              if (value == "") {
                return "Please write your infomation";
              }
            },
            // enabled: isEdit,
            // autofocus: true,
            controller: widget.textController,
            style: Constraint.Nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: (isEdit) ? Colors.white : Color(0xffd9e5f6),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.blue,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          title: Text(
            widget.title!,
            style: Constraint.Nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

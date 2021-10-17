import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../constraint.dart';

class PickDate extends StatefulWidget {
  final DateTime? beginDate;
  final DateTime? endDate;
  final void Function(DateTime begin, DateTime end) onChange;
  const PickDate({
    Key? key,
    required this.beginDate,
    required this.endDate,
    required this.onChange,
  }) : super(key: key);

  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  DateTime? beginDate;
  DateTime? endDate;
  @override
  void initState() {
    beginDate = widget.beginDate ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    endDate = widget.endDate ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    super.initState();
  }

  void _showBottomShet(
      BuildContext context, void Function(String val) changeData) {
    String ans;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        height: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              child: SfDateRangePicker(
                initialSelectedRange: PickerDateRange(beginDate, endDate),
                startRangeSelectionColor: Colors.orange,
                endRangeSelectionColor: Colors.orange,
                todayHighlightColor: Colors.blue,
                rangeSelectionColor: Color.fromRGBO(245, 161, 66, 0.2),
                selectionShape: DateRangePickerSelectionShape.rectangle,
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (args) {
                  setState(() {
                    print("Print date picker");
                    print(args.value.startDate);
                    print(args.value.endDate);
                    if (args.value.startDate != null) {
                      beginDate = args.value.startDate;
                      endDate = args.value.startDate;
                    }
                    if (args.value.endDate != null)
                      endDate = args.value.endDate;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: CustomButton(
                      buttonTitle: 'Confirm',
                      height: 50,
                      onTap: () {
                        if (beginDate!.compareTo(DateTime.now()) <= 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text("Warning"),
                              content: Text(
                                "Your picked time was in the past, please pick again",
                                style: Constraint.Nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                CustomButton(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  buttonTitle: "Confirm",
                                  textStyle: Constraint.Nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                ),
                              ],
                            ),
                          );
                        } else {
                          print("begindate = $beginDate");
                          print("endDate = $endDate");
                          if (endDate!.difference(beginDate!).inMilliseconds <
                              0.1) {
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
                                        textStyle: Constraint.Nunito(),
                                        height: 50,
                                      )
                                    ],
                                    title: Text(
                                      "Warning",
                                      style: Constraint.Nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "Your booking days need to more than 1",
                                      style: Constraint.Nunito(
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            widget.onChange(beginDate!, endDate!);
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      textStyle: Constraint.Nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showBottomShet(context, (val) {
          setState(() {});
        });
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 14,
        ),
        height: 50,
        width: 230,
        decoration: BoxDecoration(
            color: Color.fromRGBO(223, 222, 222, 0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            (beginDate.toString() == 'null')
                ? "Date"
                : "${DateFormat('dd/MM/yyyy').format(beginDate!).toString() + ' - ' + DateFormat('dd/MM/yyyy').format(endDate ?? beginDate!).toString()}",
            style: Constraint.Nunito(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
        ),
      ),
    );
  }
}

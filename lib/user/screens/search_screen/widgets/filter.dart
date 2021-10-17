import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
    required this.distance,
    required this.highPrice,
    required this.lowPrice,
    required this.type,
  }) : super(key: key);
  final double distance;
  final double lowPrice;
  final double highPrice;
  final int type;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  double distance = 4.0;
  double lowPrice = 0;
  double highPrice = 1000;
  int type = 0;
  late SearchModel searchModel;

  @override
  void initState() {
    distance = widget.distance;
    lowPrice = widget.lowPrice;
    highPrice = widget.highPrice;
    type = widget.type;
    print(distance);
    print(highPrice);
    print(lowPrice);
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchModel = Provider.of<SearchModel>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.grey[50],
      ),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Distance from your picked location:",
              style: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: Container(
              child: Slider(
                inactiveColor: Colors.orange[150],
                activeColor: Colors.orange,
                onChangeEnd: (value) {
                  searchModel.addDistance(value);
                },
                onChanged: (double value) {
                  setState(() {
                    distance = value;
                  });
                },
                value: distance,
                max: 10,
                min: 1,
                label: "$distance km",
                divisions: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Range of price:",
              style: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RangeSlider(
            inactiveColor: Colors.orange[150],
            activeColor: Colors.orange,
            labels: RangeLabels(
              "${lowPrice.toStringAsFixed(0)}\$",
              "${highPrice.toStringAsFixed(0)}\$",
            ),
            divisions: 1000,
            max: 1000,
            min: 0,
            values: RangeValues(lowPrice, highPrice),
            onChangeEnd: (values) {
              searchModel.addMaxPrice(values.end);
              searchModel.addMinPrice(values.start);
            },
            onChanged: (values) {
              setState(() {
                lowPrice = values.start;
                highPrice = values.end;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Type:",
              style: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      gradient: (type == 0 || type == 2)
                          ? LinearGradient(
                              colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            type = 0;
                            searchModel.addType(type);
                          });
                        },
                        child: Text(
                          "Homestay",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (type == 0 || type == 2)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: (type == 1 || type == 2)
                          ? Color(0xFFFFCD61)
                          : Colors.grey[350],
                    ),
                    child: ClipRRect(
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            type = 1;
                            searchModel.addType(type);
                          });
                        },
                        child: Text(
                          "Hotel",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (type == 1 || type == 2)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      gradient: (type == 2)
                          ? LinearGradient(
                              colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            type = 2;
                            searchModel.addType(type);
                          });
                        },
                        child: Text(
                          "All",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (type == 2) ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

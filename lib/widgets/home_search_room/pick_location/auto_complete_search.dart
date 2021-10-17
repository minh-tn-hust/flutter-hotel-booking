import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:http/http.dart' as http;

class AutoCompleteSearch extends StatefulWidget {
  final Function(Location picker) pickItem;
  const AutoCompleteSearch({
    Key? key,
    required this.pickItem,
  }) : super(key: key);

  @override
  _AutoCompleteSearchState createState() => _AutoCompleteSearchState();
}

class _AutoCompleteSearchState extends State<AutoCompleteSearch> {
  Location? locationPicker;
  @override
  Widget build(BuildContext context) {
    var textContrller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: textContrller,
                  autofocus: false,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontStyle: FontStyle.italic),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: (locationPicker == null)
                        ? "Search place ..."
                        : locationPicker!.text,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  String searchItem = Uri.encodeFull(pattern);
                  var response = await http.get(Uri.parse(
                      "https://api.mapbox.com/geocoding/v5/mapbox.places/$pattern.json?limit=10&country=VN&access_token=pk.eyJ1IjoidGhpZW5oYXVvY21vIiwiYSI6ImNrcTlyY2prbjBiYzgyd282a3YwbnBqNW4ifQ.EIBldMD4MZqnKLIHG5SkVw"));
                  var json = jsonDecode(response.body);
                  return List.generate(
                    4,
                    (index) => {
                      'text': json["features"][index]["text"],
                      'place_name': json["features"][index]["place_name"],
                      'latitude': (json["features"][index]["geometry"]
                              ["coordinates"][0]) *
                          1.0,
                      'longtitude': json["features"][index]["geometry"]
                              ["coordinates"][1] *
                          1.0,
                    },
                  );
                },
                itemBuilder: (context, Map suggestion) {
                  return ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    title: Text(suggestion['text']),
                    subtitle: Text('${suggestion["place_name"]}'),
                  );
                },
                onSuggestionSelected: (Map<String, dynamic> suggestion) {
                  print(suggestion.toString());
                  setState(() {
                    var location = Location.fromJson(suggestion);
                    widget.pickItem(location);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

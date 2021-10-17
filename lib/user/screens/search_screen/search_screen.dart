import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/user/screens/search_screen/widgets/filter.dart';
import 'package:hotel_booking_app/user/screens/search_screen/widgets/map_search.dart';
import 'package:hotel_booking_app/user/screens/search_screen/widgets/search_detail_listview.dart';
import 'package:hotel_booking_app/user/screens/search_screen/widgets/search_hotel_listview.dart';
import 'package:hotel_booking_app/user/screens/search_screen/widgets/search_info_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final SearchInfoModel searchModel;
  const SearchScreen({
    Key? key,
    required this.searchModel,
  }) : super(key: key);

  @override
  _SearchScreenState createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  bool options = true;
  late MapController mapController;

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    mapController = new MapController();
    var searchModel =
        Provider.of<SearchModel>(context, listen: false).searchState;
    var nights = widget.searchModel.nights;
    var guests = widget.searchModel.guests;
    var beginDate = widget.searchModel.beginDate;
    var endDate = widget.searchModel.endDate;
    var location = widget.searchModel.location;
    return FutureBuilder<List<Hotel>>(
        future: FirebaseService.instance()
            .loadHotelWithCondition(searchModel!, (e) {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Column(
            children: [
              SearchInformationBar(
                mapController: mapController,
                model: widget.searchModel,
                location: location,
                guests: guests,
                beginDate: beginDate,
                endDate: endDate,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                          context: context,
                          builder: (context) {
                            return Filter(
                              distance: searchModel.maxDistance!,
                              highPrice: searchModel.maxPrice!,
                              lowPrice: searchModel.minPrice!,
                              type: searchModel.type!,
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Filter",
                            style: Constraint.Nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          options = !options;
                          mapController = new MapController();
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            (options == false) ? "Map" : "List",
                            style: Constraint.Nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            (options == false) ? Icons.map : Icons.list,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
              ),
              (options == true)
                  ? Expanded(
                      child: Stack(
                        children: [
                          MapSearch(
                            initLocation: (location != null)
                                ? location.coordinates
                                : LatLng(21.1, 105.5),
                            mapController: mapController,
                            callBack: () {
                              setState(() {});
                            },
                            children: snapshot.data!,
                          ),
                          (snapshot.data!.length != 0)
                              ? Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: SearchHotelListView(
                                    children: snapshot.data!,
                                    mapController: mapController,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SearchDetailListview(children: snapshot.data!),
            ],
          );
        });
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/icons.dart';
import 'package:liderfacilites/models/setting.dart';

class TaskerHome extends StatefulWidget {
  const TaskerHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaskerHomeState();
  }
}

class TaskerHomeState extends State<TaskerHome> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // List<DocumentSnapshot> listOfTaskers;
  var tasker;
  var taskerId;
  bool showUserProfile = false;

  CustomFirestore _customFirestore = new CustomFirestore();
  User _user = new User();

  final MarkerId mId = MarkerId('mylocation');
  //current location
  Geolocator geolocator = Geolocator();
  Position userLocation;
  static double zoomValue = 17;
  // GeoPoint _geoPoint = new GeoPoint(0, 0);
  GeoPoint _geoPoint = new GeoPoint(30.3753, 69.3451);
  BitmapDescriptor mylocationIcon;
  //Tasker progile image url
  String _imageUrl;
  //setting to get mylocationicon
  Setting setting = new Setting();
  CustomIcon icon = new CustomIcon();
  //clicked service is fav or not
  bool fav = false;
  //
  var lang;

  // GeoPoint _geoPoint;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  static CameraPosition _newLocation;

  @override
  void initState() {
    _geoPoint = setting.location;
    _getLocation().then((position) {
      userLocation = position;
      _geoPoint = new GeoPoint(userLocation.latitude, userLocation.longitude);
      //set user to SP. So next time google map should not be zoom in
      setting.setLocationToSP(_geoPoint);
      setMyLocationMarker();
      _newLocation = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(_geoPoint.latitude, _geoPoint.longitude),
          // tilt: 59.440717697143555,
          zoom: zoomValue);

      _goToNewLocation(_newLocation);
    });
    // populateTaskers();
    super.initState();
  }

  setMyLocationMarker() {
    final Marker marker = Marker(
        markerId: mId,
        position: LatLng(_geoPoint.latitude, _geoPoint.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: icon.getmyLocationIcon,
        onTap: () {
          setState(() {
            showUserProfile = false;
          });
        });
    if (this.mounted) {
      setState(() {
        markers[mId] = marker;
      });
    }

    debugPrint('called');
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  populateTaskers() async {
    Firestore.instance.collection("services").getDocuments().then((docs) => {
          if (docs.documents.isNotEmpty)
            {
              for (int i = 0; i < docs.documents.length; ++i)
                {
                  initMarker(
                      docs.documents[i].data, docs.documents[i].documentID)
                }
            }
        });
  }

  initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(request['geopoint'].latitude, request['geopoint'].longitude),
        onTap: () {
          tasker = request;
          taskerId = markerId.value;
          _imageUrl = tasker['imgurl'];

          List<String> listoffav = _user.favoriteList;
          fav = false;
          for (int i = 0; i < listoffav.length; i++) {
            if (listoffav[i] == taskerId) {
              fav = true;
              break;
            }
          }

          if (this.mounted) {
            setState(() {
              showUserProfile = true;
              print('id: ' + markerId.value.toString());
            });
          }
        });
    if (this.mounted) {
      setState(() {
        markers[markerId] = marker;
        print(markerId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context);
    return Scaffold(
        body:
            // Center(child: Text('center'),),
            Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          markers: Set<Marker>.of(markers.values),
          initialCameraPosition: CameraPosition(
            target: LatLng(
                _geoPoint.latitude ?? 30.3753, _geoPoint.longitude ?? 69.3451),
            zoom: _geoPoint.latitude == 30.3753 ? 6 : zoomValue,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (geopoint) {
            setState(() {
              showUserProfile = false;
              print('Lat: ' +
                  geopoint.latitude.toString() +
                  ' Long: ' +
                  geopoint.longitude.toString());
            });
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Column(
            children: <Widget>[
              uperPart(),
              searchTF(),
            ],
          ),
        ),
        Visibility(
            visible: true,
            // visible: showUserProfile,
            child: Positioned(
              bottom: 5.0,
              left: 5.0,
              right: 5.0,
              child: Column(
                children: <Widget>[
                  Transform.translate(
                      offset: Offset(0, 30),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: setting.taskerViewColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text('You have 13 minutes to respond',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  // backgroundColor: Colors.black,
                                  child: ClipOval(
                                      child: _imageUrl == null
                                          ? Image.asset(
                                              'assets/images/account.png',
                                            )
                                          : Image.network(
                                              _imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            )),
                                ),
                                title: Text('Service Requested'),
                                subtitle: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                // record.type,
                                                'Type1')),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              // record.subtype,
                                              'Type 2',
                                            )),
                                      ],
                                    )),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black12, width: 2)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              //todo tasker chat page
                                              print('navigate to chage page');
                                            },
                                            child: Icon(
                                              Icons.message,
                                              color: Colors.black38,
                                              size: 15,
                                            ),
                                          ))),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 12, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('15 min away',
                                          style:
                                              TextStyle(color: Colors.green)),
                                      Text(
                                        '15 \$',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            print(
                                                'line between tasker and buyer');
                                          },
                                          child: Icon(Icons.directions)),
                                    ],
                                  )),
                              Divider(),
                              acceptRejectBtn(),
                            ],
                          ))),
                ],
              ),
            )),
      ],
    )

        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToNewLocation,
        //   label: Text('To the lake!'),
        //   icon: Icon(Icons.directions_boat),
        // ),
        );
  }

  Future<void> _goToNewLocation(CameraPosition cameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.5,
      decoration: BoxDecoration(
          color: setting.taskerViewColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Lider Facilities',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19),
              ))),
    );
  }

  searchTF() {
    return Transform.translate(
        offset: Offset(0, -25),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                padding: EdgeInsets.only(left: 20, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
                child: Row(children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  Flexible(
                      child: TextFormField(
                    // textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        // hintText: 'Email',
                        hintText: lang.translate('Search'),
                        border: InputBorder.none,
                        fillColor: Colors.blue),
                  )),
                ]),
              )
            ],
          ),
        ));
  }

  acceptRejectBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Container(
          child: Row(
        children: <Widget>[
          Expanded(
              flex: 8,
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.black54)),
                onPressed: () {},
                child: Text(
                  lang.translate('Accept'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.blueAccent),
                ),
              )),
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 8,
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Color.fromRGBO(26, 119, 186, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  // navigateToPaymentPage();
                },
                child: Text(
                  lang.translate('Reject'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white),
                ),
              )),
        ],
      )),
    );
  }
}

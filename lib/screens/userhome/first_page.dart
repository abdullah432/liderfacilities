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

class FirstPage extends StatefulWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FirstPageState();
  }
}

class FirstPageState extends State<FirstPage> {
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
  static double zoomValue = 13;
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

  static CameraPosition _newLocation = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      // tilt: 59.440717697143555,
      zoom: zoomValue);

  @override
  void initState() {
    _getLocation().then((position) {
      userLocation = position;
      _geoPoint = new GeoPoint(userLocation.latitude, userLocation.longitude);
      setMyLocationMarker();
      _newLocation = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(_geoPoint.latitude, _geoPoint.longitude),
          // tilt: 59.440717697143555,
          zoom: zoomValue);

      _goToNewLocation(_newLocation);
    });
    populateTaskers();
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
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  // getCurrentLocation() async {
  //   try {
  //     userLocation = await geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //   } catch (e) {
  //     userLocation = null;
  //   }

  //   _locationData = await location.getLocation();
  //   _geoPoint = new GeoPoint(_locationData.latitude, _locationData.longitude);
  //   debugPrint('before set location marker');
  //   setState(() {
  //     setMyLocationMarker();
  //     _newLocation = CameraPosition(
  //         // bearing: 192.8334901395799,
  //         target: LatLng(_geoPoint.latitude, _geoPoint.longitude),
  //         // tilt: 59.440717697143555,
  //         zoom: zoomValue);

  //     _goToNewLocation(_newLocation);
  //   });
  // }

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
        icon: getMarkerIcon(request['type']),
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
            zoom: 6,
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
            visible: showUserProfile,
            child: Positioned(
              bottom: 5.0,
              left: 5.0,
              right: 5.0,
              child: Card(
                  child: ListTile(
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
                title: tasker == null
                    ? Text('taskername')
                    : Text(tasker['taskername']),
                subtitle: tasker == null
                    ? Text('description')
                    : Text(tasker['description']),

                // subtitle: tasker['description'] ?? 'description',
                trailing:
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: fav == true ? Colors.green : Colors.black12, width: 2)),
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              //todo tasker chat page
                              print('save');
                              // print('ref: '+taskerId);
                              if (!fav){
                                _customFirestore.addServiceToFavourit(taskerId);
                                setState(() {
                                  fav = true;
                                });
                                
                              }
                              else{
                                _customFirestore.removeServiceFromFavourite(taskerId);
                                setState(() {
                                  fav = false;
                                });
                              }
                            },
                            child: Icon(
                              Icons.favorite,
                              color: fav == true ? Colors.green : Colors.black12,
                              size: 15,
                            ),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.black12, width: 2)),
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
                ]),
              )),
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

  getMarkerIcon(type) {
    debugPrint('type: ' + type.toString());
    if (type == 'DE LIMPEZA' || type == 'CLEANING')
      return icon.cleaning;
    else if (type == 'REPARAR' || type == 'REPAIR')
      return icon.repair;
    else if (type == 'REPARAR' || type == 'HEALTH') return icon.repair;
    // switch (type) {
    //   case 'CLEANING':
    //     return icon.cleaning;
    //     break;
    //   case 'REPAIR':
    //     return icon.repair;
    //     break;
    //   case 'HEALTH':
    //     return icon.health;
    //     break;
    //   case 'WEEDING':
    //     return icon.weeding;
    //     break;
    //   case 'BUISNESS':
    //     return icon.weeding;
    //     break;
    //   default:
    //     return BitmapDescriptor.defaultMarker;
    // }
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.5,
      decoration: BoxDecoration(
          color: Color.fromRGBO(26, 119, 186, 1),
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
}

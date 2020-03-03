import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/icons.dart';
import 'package:liderfacilites/models/services.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/chatroom/chat.dart';

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

  // //icon is final so can't changed
  //selected type
  String selectedType = '';

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
  //listOfIcons is list of services type icons
  final listOfIcons = Services.listOfIcons;
  final listOfSelectedIcons = Services.listOfSelectedIcons;

  // GeoPoint _geoPoint;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  static CameraPosition _newLocation;

  @override
  void initState() {
    _geoPoint = setting.location;
    debugPrint('geopoints: ' +
        _geoPoint.latitude.toString() +
        "  " +
        _geoPoint.longitude.toString());
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
    populateTaskers();
    super.initState();
  }

  setMyLocationMarker() {
    Marker marker = Marker(
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
            //icon is final so can't changed
            // //set selected type, icon will be change to selected. When click on outside, box will diapear and icon will be normal
            // selectedType = request['type'];
            // markers[taskerId].icon = getMarkerIcon(request['type']);
            setState(() {
              //remove cursor blink of search textfield
              FocusScope.of(context).requestFocus(new FocusNode());

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
              //remove cursor blink of search textfield
              FocusScope.of(context).requestFocus(new FocusNode());

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
                // searchTF(),
                typeScrollView()
              ],
            )
            // Stack(
            //   children: <Widget>[
            //    Positioned(
            //         bottom: 0, left: 0, right: 0, child: typeScrollView()),
            //     Positioned(top: 0, left: 0, right: 0, child: uperPart()),
            //     Align(
            //       alignment: Alignment.center,
            //       child: searchTF(),
            //     )
            //   ],
            // ),
            ),
        bottomServiceView(),
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
    print('icon called');
    if (type == 'DE LIMPEZA' || type == 'CLEANING')
      return icon.cleaning;
    else if (type == 'REPARAR' || type == 'REPAIR')
      return icon.repair;
    // else if (type == 'REPARAR' || type == 'HEALTH')
    //   return icon.repair;
    else if (type == 'AIR CONDITIONING' || type == 'DE AR-CONDICIONADO')
      return icon.ac;
    else if (type == 'DRIVER' || type == 'MOTORISTA')
      return icon.car;
    else if (type == 'ELECTRICAL' || type == 'ELÉTRICOS')
      return icon.electrical;
    else if (type == 'MUSIC' || type == 'MUSICA')
      return icon.music;
    else if (type == 'HYDRAULIC' || type == 'HIDRÁULICOS')
      return icon.hydraulic;
    else if (type == 'REFORM' || type == 'DE REFORMA')
      return icon.reform;
    else if (type == 'FURNITURE ASSEMBLY' || type == 'MONTAGEM DE MÓVEIS')
      return icon.furnitureAssembly;
    else if (type == 'TECHNICAL ASSISTANCE' || type == 'ASSISTÊNCIA TÉCNICA')
      return icon.technicalassistance;
    else if (type == 'MASSAGES AND THERAPIES' || type == 'MASSAGENS E TERAPIAS')
      return icon.massage;
    else if (type == 'PARTY ANIMATION' || type == 'ANIMACÃO DE FESTAS')
      return icon.kidparty;
    else if (type == 'BIKEBOY' || type == 'BIKEBOY')
      return icon.biker;
    else if (type == 'LOCKSMITH' || type == 'CHAVEIRO')
      return icon.locksmith;
    else if (type == 'ELDERLY CAREGIVER' || type == 'CUIDADOR IDOSO')
      return icon.eldercare;
    else if (type == 'PHOTOGRAPHER' || type == 'FOTOGRAFO')
      return icon.photographer;
    else if (type == 'GARDENER' || type == 'JARDINEIRO')
      return icon.gardner;
    else if (type == 'CAR WASH' || type == 'LAVAGEM DE CARRO')
      return icon.carwash;
    else if (type == 'PETS' || type == 'PETS')
      return icon.pets;
    else if (type == 'MANICURE' || type == 'MANICURE')
      return icon.manicure;
    else if (type == 'FOOD' || type == 'ALIMENTAÇÃO')
      return icon.food;
    else if (type == 'AUTOMOBILES' || type == 'AUTOMOVEIS')
      return icon.automobiles;
    else if (type == 'MAINTENANCE' || type == 'MANUTENÇÃO')
      return icon.maintanace;
    else if (type == 'PERSONAL TRAINER' || type == 'PERSONAL TRAINER')
      return icon.personaltrainer;
    else
      return BitmapDescriptor.defaultMarker;
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
      height: MediaQuery.of(context).size.height / 7,
      color: Color.fromRGBO(26, 119, 186, 1),
      // decoration: BoxDecoration(
      //     color: Color.fromRGBO(26, 119, 186, 1),
      //     borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(20),
      //         bottomRight: Radius.circular(20))),
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
                height: 44,
                padding: EdgeInsets.only(left: 20, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
                child: Row(children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.black38,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: TextFormField(
                    style: TextStyle(fontSize: 16),
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

  typeScrollView() {
    // return ListView.builder(
    //   scrollDirection: Axis.horizontal,
    //   itemCount: 4,
    //   itemBuilder: (context, index) {
    //             FlatButton(
    //           onPressed: () => {},
    //           padding: EdgeInsets.all(10.0),
    //           child: Column( // Replace with a Row for horizontal icon + text
    //             children: <Widget>[
    //               Icon(Icons.add),
    //               Text("Add")
    //             ],
    //           )
    //       )
    // });
    return
        // Transform.translate(
        //     offset: Offset(0, -25),
        //   child:
        Container(
            color: Color.fromARGB(255, 235, 235, 235),
            child: SizedBox(
                height: 75,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: _getListData()
                    // )
                    )));
  }

  _getListData() {
    List<Widget> widgets = [];
    final listOfServices = setting.getLanguage() == 'English'
        ? Services.typeofservicesInENG
        : Services.typeofservicesInBR;

    // print('services' + listOfServices.length.toString());
    // print('icons' + listOfIcons.length.toString());
    for (int i = 0; i < listOfServices.length; i++) {
      widgets.add(FlatButton(
          onPressed: () => {
                setState(() {
                  selectedType = listOfServices[i];
                }),
              },
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Image(
                  width: 40,
                  height: 40,
                  image: getServiceTypeIcon(listOfServices[i])),
              SizedBox(
                height: 4,
              ),
              Expanded(
                  child: Text(listOfServices[i],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      )))
            ],
          )));
    }
    return widgets;
  }

  getServiceTypeIcon(type) {
    debugPrint('selected: '+selectedType.toString());
    // debugPrint('pass type: '+type.toString());
    if (type == 'DE LIMPEZA' || type == 'CLEANING' && selectedType != type)
      return Services.unselectedcleaning;
    else if ((type == 'DE LIMPEZA' ||
        type == 'CLEANING') && selectedType == type) {
      print('selectcleaning called');
      return Services.selectedcleaning;
    } else if ((type == 'DRIVER' ||
        type == 'MOTORISTA') && selectedType != type) {
      print('unselected driver called');
      return Services.unselectedcar;
    } else if ((type == 'DRIVER' ||
        type == 'MOTORISTA') && selectedType == type) {
      print('selected driver called');
      return Services.selectedcar;
    }
    // else if (type == 'ELECTRICAL' || type == 'ELÉTRICOS')
    //   return listOfIcons[index];
    // else if (type == 'REPARAR' || type == 'REPAIR' && selectedType == '')
    //   return listOfIcons[index];
    // // else if (type == 'REPARAR' || type == 'HEALTH')
    // //   return icon.repair;
    // else if (type == 'AIR CONDITIONING' || type == 'DE AR-CONDICIONADO')
    //   return listOfIcons[index];
    // else if (type == 'MUSIC' || type == 'MUSICA')
    //   return listOfIcons[index];
    // else if (type == 'HYDRAULIC' || type == 'HIDRÁULICOS')
    //   return listOfIcons[index];
    // else if (type == 'REFORM' || type == 'DE REFORMA')
    //   return listOfIcons[index];
    // else if (type == 'FURNITURE ASSEMBLY' || type == 'MONTAGEM DE MÓVEIS')
    //   return listOfIcons[index];
    // else if (type == 'TECHNICAL ASSISTANCE' || type == 'ASSISTÊNCIA TÉCNICA')
    //   return listOfIcons[index];
    // else if (type == 'MASSAGES AND THERAPIES' || type == 'MASSAGENS E TERAPIAS')
    //   return listOfIcons[index];
    // else if (type == 'PARTY ANIMATION' || type == 'ANIMACÃO DE FESTAS')
    //   return listOfIcons[index];
    // else if (type == 'BIKEBOY' || type == 'BIKEBOY')
    //   return listOfIcons[index];
    // else if (type == 'LOCKSMITH' || type == 'CHAVEIRO')
    //   return listOfIcons[index];
    // else if (type == 'ELDERLY CAREGIVER' || type == 'CUIDADOR IDOSO')
    //   return listOfIcons[index];
    // else if (type == 'PHOTOGRAPHER' || type == 'FOTOGRAFO')
    //   return listOfIcons[index];
    // else if (type == 'GARDENER' || type == 'JARDINEIRO')
    //   return listOfIcons[index];
    // else if (type == 'CAR WASH' || type == 'LAVAGEM DE CARRO')
    //   return listOfIcons[index];
    // else if (type == 'PETS' || type == 'PETS')
    //   return listOfIcons[index];
    // else if (type == 'MANICURE' || type == 'MANICURE')
    //   return listOfIcons[index];
    // else if (type == 'FOOD' || type == 'ALIMENTAÇÃO')
    //   return listOfIcons[index];
    // else if (type == 'AUTOMOBILES' || type == 'AUTOMOVEIS')
    //   return listOfIcons[index];
    // else if (type == 'MAINTENANCE' || type == 'MANUTENÇÃO')
    //   return listOfIcons[index];
    // else if (type == 'PERSONAL TRAINER' || type == 'PERSONAL TRAINER')
    //   return listOfIcons[index];
    else
      return Services.unselectedelectrical;
  }

  bottomServiceView() {
    return Visibility(
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
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: fav == true ? Colors.green : Colors.black12,
                          width: 2)),
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          //todo tasker chat page
                          print('save');
                          // print('ref: '+taskerId);
                          if (!fav) {
                            _customFirestore.addServiceToFavourit(taskerId);
                            setState(() {
                              fav = true;
                            });
                          } else {
                            _customFirestore
                                .removeServiceFromFavourite(taskerId);
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
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            //we need user id not service id
                            DocumentReference docRef = tasker['reference'];
                            //todo tasker chat page
                            print('navigate to chage page');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                          peerId: docRef.documentID,
                                          peerAvatar: tasker['imgurl'],
                                          peername: tasker['taskername'],
                                        )));
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
        ));
  }
}

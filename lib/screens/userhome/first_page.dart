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
import 'package:liderfacilites/screens/payment/book1.dart';

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
  String selectedSubType = '';

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
  //subtype scrollview
  bool subtypeScrollVisiblity = false;
  var listOfSubtype;
  List<DocumentSnapshot> allServices;

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
          if (docs.documents != null)
            {
              if (docs.documents.isNotEmpty)
                {
                  allServices = docs.documents,
                  for (int i = 0; i < docs.documents.length; ++i)
                    {
                      initMarker(
                          docs.documents[i].data, docs.documents[i].documentID)
                    }
                }
            }
        });
  }

  filterTasker(type, filterType, subtype) async {
    markers.clear();
    if (filterType == 0) {
      //filter w.r.t type
      List<DocumentSnapshot> filterList =
          allServices.where((element) => element['type'] == type).toList();
      if (filterList.isNotEmpty) {
        for (int i = 0; i < filterList.length; i++) {
          initMarker(filterList[i].data, filterList[i].documentID);
        }
      }
    } else if (filterType == 1) {
      //filter w.r.t type and it's subtype
      List<DocumentSnapshot> filterList = allServices
          .where((element) =>
              element['type'] == type && element['subtype'] == subtype)
          .toList();
      if (filterList.isNotEmpty) {
        for (int i = 0; i < filterList.length; i++) {
          initMarker(filterList[i].data, filterList[i].documentID);
        }
      }
    } else if (filterType == 2) {
      //remove filter
      if (allServices.isNotEmpty) {
        for (int i = 0; i < allServices.length; i++) {
          initMarker(allServices[i].data, allServices[i].documentID);
        }
      }
    }
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
              // print('length of Services list: '+allServices.length.toString());
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
                typeScrollView(),
                Visibility(
                    visible: subtypeScrollVisiblity,
                    child: subtypeScrollView()),
              ],
            )
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

    //we will always use enlish list for filtering
    final listOfServicesInEng = Services.typeofservicesInENG;

    // print('services' + listOfServices.length.toString());
    // print('icons' + listOfIcons.length.toString());
    for (int i = 0; i < listOfServices.length; i++) {
      widgets.add(FlatButton(
          onPressed: () => {
                setState(() {
                  if (selectedType == listOfServicesInEng[i]) {
                    //that means user click on selected type again
                    //empty selected type
                    selectedType = '';
                    subtypeScrollVisiblity = false;
                    //restore all marker
                    filterTasker(selectedType, 2, '');
                  } else {
                    selectedType = listOfServicesInEng[i];
                    subtypeScrollVisiblity = true;
                    // debugPrint('selectedType: ' + selectedType.toString());
                    if (selectedType != '') {
                      filterTasker(selectedType, 0, '');
                    }
                  }
                }),
              },
          padding: EdgeInsets.only(top: 10.0, right: 5),
          child: Column(
            // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Image(
                  width: 40,
                  height: 40,
                  image: getServiceTypeIcon(listOfServicesInEng[i])),
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

  subtypeScrollView() {
    return Container(
        color: Colors.white,
        child: SizedBox(
            height: 35,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: _getSubtypeList()
                // )
                )));
  }

  _getSubtypeList() {
    List<Widget> widgets = [];
    // var listOfSubServices = setting.getLanguage() == 'English'
    //     ? Services.typeofservicesInENG
    //     : Services.typeofservicesInBR;

    var listOfSubServices = getListOfSubServices();

    // print('services' + listOfServices.length.toString());
    // print('icons' + listOfIcons.length.toString());
    for (int i = 0; i < listOfSubServices.length; i++) {
      widgets.add(FlatButton(
          onPressed: () => {
                setState(() {
                  if (selectedSubType == listOfSubServices[i]) {
                    //that means user click on selected type again
                    //empty selected type
                    selectedSubType = '';
                    //restore marker of type mean remove filteration of subtype
                    filterTasker(selectedType, 0, '');
                  } else {
                    selectedSubType = listOfSubServices[i];
                    if (selectedSubType != '') {
                      filterTasker(selectedType, 1, selectedSubType);
                    }
                  }
                }),
              },
          padding: EdgeInsets.only(top: 10.0, right: 5, left: 5),
          child: Expanded(
              child: Text(listOfSubServices[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: selectedSubType == listOfSubServices[i]
                        ? Colors.blue
                        : Colors.black87,
                  )))));
    }
    return widgets;
  }

  getServiceTypeIcon(type) {
    // debugPrint('selected: '+selectedType.toString());
    // debugPrint('pass type: '+type.toString());
    if (type == 'DE LIMPEZA' || type == 'CLEANING' && selectedType != type)
      return Services.unselectedcleaning;
    else if ((type == 'DE LIMPEZA' || type == 'CLEANING') &&
        selectedType == type) {
      return Services.selectedcleaning;
    } else if ((type == 'DRIVER' || type == 'MOTORISTA') &&
        selectedType != type) {
      return Services.unselectedcar;
    } else if ((type == 'DRIVER' || type == 'MOTORISTA') &&
        selectedType == type) {
      return Services.selectedcar;
    } else if ((type == 'ELECTRICAL' || type == 'ELÉTRICOS') &&
        selectedType != type) {
      return Services.unselectedelectrical;
    } else if ((type == 'ELECTRICAL' || type == 'ELÉTRICOS') &&
        selectedType == type) {
      return Services.selectedelectrical;
    } else if ((type == 'AIR CONDITIONING' || type == 'DE AR-CONDICIONADO') &&
        selectedType != type)
      return Services.unselectedac;
    else if ((type == 'AIR CONDITIONING' || type == 'DE AR-CONDICIONADO') &&
        selectedType == type)
      return Services.selectedac;
    else if ((type == 'MUSIC' || type == 'MUSICA') && selectedType != type) {
      return Services.unselectedmusic;
    } else if ((type == 'MUSIC' || type == 'MUSICA') && selectedType == type) {
      return Services.selectedmusic;
    } else if ((lang == 'HYDRAULIC' || type == 'HIDRÁULICOS') &&
        selectedType != type)
      return Services.unselectedhydraulic;
    else if ((lang == 'HYDRAULIC' || type == 'HIDRÁULICOS') &&
        selectedType == type)
      return Services.selectedhydraulic;
    else if ((type == 'REFORM' || type == 'DE REFORMA') && selectedType != type)
      return Services.unselectedreform;
    else if ((type == 'REFORM' || type == 'DE REFORMA') && selectedType == type)
      return Services.selectedreform;
    else if ((type == 'FURNITURE ASSEMBLY' || type == 'MONTAGEM DE MÓVEIS') &&
        selectedType != type)
      return Services.unselectedfa;
    else if ((type == 'FURNITURE ASSEMBLY' || type == 'MONTAGEM DE MÓVEIS') &&
        selectedType == type)
      return Services.selectedfa;
    else if ((type == 'TECHNICAL ASSISTANCE' ||
            type == 'ASSISTÊNCIA TÉCNICA') &&
        selectedType != type)
      return Services.unselectedtechnicalassistance;
    else if ((type == 'TECHNICAL ASSISTANCE' ||
            type == 'ASSISTÊNCIA TÉCNICA') &&
        selectedType == type)
      return Services.selectedtechnicalassistance;
    else if ((type == 'MASSAGES AND THERAPIES' ||
            type == 'MASSAGENS E TERAPIAS') &&
        selectedType != type)
      return Services.unselectedmassage;
    else if ((type == 'MASSAGES AND THERAPIES' ||
            type == 'MASSAGENS E TERAPIAS') &&
        selectedType == type)
      return Services.selectedmassage;
    else if ((type == 'PARTY ANIMATION' || type == 'ANIMACÃO DE FESTAS') &&
        selectedType != type)
      return Services.unselectedkidparty;
    else if ((type == 'PARTY ANIMATION' || type == 'ANIMACÃO DE FESTAS') &&
        selectedType == type)
      return Services.selectedkidparty;
    else if ((type == 'BIKEBOY' || type == 'BIKEBOY') && selectedType != type)
      return Services.unselectedbiker;
    else if ((type == 'BIKEBOY' || type == 'BIKEBOY') && selectedType == type)
      return Services.selectedbiker;
    else if ((type == 'LOCKSMITH' || type == 'CHAVEIRO') &&
        selectedType != type)
      return Services.unselectedlocksmith;
    else if ((type == 'LOCKSMITH' || type == 'CHAVEIRO') &&
        selectedType == type)
      return Services.selectedlocksmith;
    else if ((type == 'ELDERLY CAREGIVER' || type == 'CUIDADOR IDOSO') &&
        selectedType != type)
      return Services.unselectedeldercare;
    else if ((type == 'ELDERLY CAREGIVER' || type == 'CUIDADOR IDOSO') &&
        selectedType == type)
      return Services.selectedeldercare;
    else if ((type == 'PHOTOGRAPHER' || type == 'FOTOGRAFO') &&
        selectedType != type)
      return Services.unselectedphotographer;
    else if ((type == 'PHOTOGRAPHER' || type == 'FOTOGRAFO') &&
        selectedType == type)
      return Services.selectedphotographer;
    else if ((type == 'GARDENER' || type == 'JARDINEIRO') &&
        selectedType != type)
      return Services.unselectedgardner;
    else if ((type == 'GARDENER' || type == 'JARDINEIRO') &&
        selectedType == type)
      return Services.selectedgardner;
    else if ((type == 'CAR WASH' || type == 'LAVAGEM DE CARRO') &&
        selectedType != type)
      return Services.unselectedcarwash;
    else if ((type == 'CAR WASH' || type == 'LAVAGEM DE CARRO') &&
        selectedType == type)
      return Services.selectedcarwash;
    else if ((type == 'PETS') && selectedType != type)
      return Services.unselectedpets;
    else if ((type == 'PETS') && selectedType == type)
      return Services.selectedpets;
    else if (type == 'MANICURE' && selectedType != type)
      return Services.unselectedmanicure;
    else if (type == 'MANICURE' && selectedType == type)
      return Services.selectedmanicure;
    else if ((type == 'FOOD' || type == 'ALIMENTAÇÃO') && selectedType != type)
      return Services.unselectedfood;
    else if ((type == 'FOOD' || type == 'ALIMENTAÇÃO') && selectedType == type)
      return Services.selectedfood;
    else if ((type == 'AUTOMOBILES' || type == 'AUTOMOVEIS') &&
        selectedType != type)
      return Services.unselectautomobile;
    else if ((type == 'AUTOMOBILES' || type == 'AUTOMOVEIS') &&
        selectedType == type)
      return Services.selectedautomobile;
    else if ((type == 'MAINTENANCE' || type == 'MANUTENÇÃO') &&
        selectedType != type)
      return Services.unselectedmaintanance;
    else if ((type == 'MAINTENANCE' || type == 'MANUTENÇÃO') &&
        selectedType == type)
      return Services.selectedmaintanance;
    else if ((type == 'PERSONAL TRAINER' || type == 'PERSONAL TRAINER') &&
        selectedType != type)
      return Services.unselectedpersonaltrainer;
    else if ((type == 'PERSONAL TRAINER' || type == 'PERSONAL TRAINER') &&
        selectedType == type)
      return Services.selectedpersonaltrainer;
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
            child: GestureDetector(
              onTap: () {
                navigateToBook1Page();
              },
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                            border: Border.all(
                                color:
                                    fav == true ? Colors.green : Colors.black12,
                                width: 2)),
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                //todo tasker chat page
                                print('save');
                                // print('ref: '+taskerId);
                                if (!fav) {
                                  _customFirestore
                                      .addServiceToFavourit(taskerId);
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
                                color:
                                    fav == true ? Colors.green : Colors.black12,
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
                                  //we need user id not service id
                                  DocumentReference docRef =
                                      tasker['reference'];
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
                ),
              )),
            )));
  }

  getListOfSubServices() {
    var selectedLanguage = setting.getLanguage();
    var type = selectedType;

    if (type == 'CLEANING' && selectedLanguage == 'English')
      return Services.subtypeofcleaningInENG;
    else if (type == 'CLEANING' && selectedLanguage == 'Portuguese') {
      return Services.subtypeofcleaningInBR;
    } else if (type == 'DRIVER' && selectedLanguage == 'English') {
      return Services.subtypeofDriverInENG;
    } else if (type == 'DRIVER' && selectedLanguage == 'Portuguese') {
      return Services.subtypeofDriverInBR;
    } else if (type == 'ELECTRICAL' && selectedLanguage == 'English') {
      return Services.subtypeofElectricalInENG;
    } else if (type == 'ELECTRICAL' && selectedLanguage == 'Portuguese') {
      return Services.subtypeofElectricalInBR;
    } else if (type == 'AIR CONDITIONING' && selectedLanguage == 'English')
      return Services.subtypeofAirCONDITIONINGInENG;
    else if (type == 'AIR CONDITIONING' && selectedLanguage == 'Portuguese')
      return Services.subtypeofAirCONDITIONINGInBR;
    else if (type == 'MUSIC' && selectedLanguage == 'English') {
      return Services.subtypeofMusicInENG;
    } else if (type == 'MUSIC' && selectedLanguage == 'Portuguese')
      return Services.subtypeofMusicInBR;
    else if (type == 'HYDRAULIC' && selectedLanguage == 'English')
      return Services.subtypeofHYDRAULICInENG;
    else if (type == 'HYDRAULIC' && selectedLanguage == 'Portuguese')
      return Services.subtypeofHYDRAULICInBR;
    else if (type == 'REFORM' && selectedLanguage == 'English')
      return Services.subtypeofREFORMInENG;
    else if (type == 'REFORM' && selectedLanguage == 'Portuguese')
      return Services.subtypeofREFORMInBR;
    else if (type == 'FURNITURE ASSEMBLY' && selectedLanguage == 'English')
      return Services.subtypeofFURNITUREASSEMBLYInENG;
    else if (type == 'FURNITURE ASSEMBLY' && selectedLanguage == 'Portuguese')
      return Services.subtypeofFURNITUREASSEMBLYInBR;
    else if (type == 'TECHNICAL ASSISTANCE' && selectedLanguage == 'English')
      return Services.subtypeofTECHNICALASSISTANCEInENG;
    else if (type == 'TECHNICAL ASSISTANCE' && selectedLanguage == 'Portuguese')
      return Services.subtypeofTECHNICALASSISTANCEInBR;
    else if (type == 'MASSAGES AND THERAPIES' && selectedLanguage == 'English')
      return Services.subtypeofMASSAGESandTHERAPIESInENG;
    else if (type == 'MASSAGES AND THERAPIES' &&
        selectedLanguage == 'Portuguese')
      return Services.subtypeofMASSAGESandTHERAPIESInBR;
    else if (type == 'PARTY ANIMATION' && selectedLanguage == 'English')
      return Services.subtypeofPARTYANIMATIONInENG;
    else if (type == 'PARTY ANIMATION' && selectedLanguage == 'Portuguese')
      return Services.subtypeofPARTYANIMATIONInBR;
    else if (type == 'BIKEBOY' && selectedLanguage == 'English')
      return Services.subtypeofBIKEBOYInENG;
    else if (type == 'BIKEBOY' && selectedLanguage == 'Portuguese')
      return Services.subtypeofBIKEBOYInBR;
    else if (type == 'LOCKSMITH' && selectedLanguage == 'English')
      return Services.subtypeofLOCKSMITHInENG;
    else if (type == 'LOCKSMITH' && selectedLanguage == 'Portuguese')
      return Services.subtypeofLOCKSMITHInBR;
    else if (type == 'ELDERLY CAREGIVER' && selectedLanguage == 'English')
      return Services.subtypeofELDERLYCAREGIVERInENG;
    else if (type == 'ELDERLY CAREGIVER' && selectedLanguage == 'Portuguese')
      return Services.subtypeofELDERLYCAREGIVERInBR;
    else if (type == 'PHOTOGRAPHER' && selectedLanguage == 'English')
      return Services.subtypeofPHOTOGRAPHERInENG;
    else if (type == 'PHOTOGRAPHER' && selectedLanguage == 'Portuguese')
      return Services.subtypeofPHOTOGRAPHERInBR;
    else if (type == 'GARDENER' && selectedLanguage == 'English')
      return Services.subtypeofGARDENERInENG;
    else if (type == 'GARDENER' && selectedLanguage == 'Portuguese')
      return Services.subtypeofGARDENERInBR;
    else if (type == 'CAR WASH' && selectedLanguage == 'English')
      return Services.subtypeofCARWASHInENG;
    else if (type == 'CAR WASH' && selectedLanguage == 'Portuguese')
      return Services.subtypeofCARWASHInBR;
    else if (type == 'PETS' && selectedLanguage == 'English')
      return Services.subtypeofPETSInENG;
    else if (type == 'PETS' && selectedLanguage == 'Portuguese')
      return Services.subtypeofPETSInBR;
    else if (type == 'MANICURE' && selectedLanguage == 'English')
      return Services.subtypeofMAINTENANCEInENG;
    else if (type == 'MANICURE' && selectedLanguage == 'Portuguese')
      return Services.subtypeofMAINTENANCEInBR;
    else if (type == 'FOOD' && selectedLanguage == 'English')
      return Services.subtypeofFOODInENG;
    else if (type == 'FOOD' && selectedLanguage == 'Portuguese')
      return Services.subtypeofFOODInBR;
    else if (type == 'AUTOMOBILES' && selectedLanguage == 'English')
      return Services.subtypeofAUTOMOBILESInENG;
    else if (type == 'AUTOMOBILES' && selectedLanguage == 'Portuguese')
      return Services.subtypeofAUTOMOBILESInBR;
    else if (type == 'MAINTENANCE' && selectedLanguage == 'English')
      return Services.subtypeofMAINTENANCEInENG;
    else if (type == 'MAINTENANCE' && selectedLanguage == 'Portuguese')
      return Services.subtypeofMAINTENANCEInBR;
    else if (type == 'PERSONAL TRAINER' && selectedLanguage == 'English')
      return Services.subtypeofPERSONALTRAINERInENG;
    else if (type == 'PERSONAL TRAINER' && selectedLanguage == 'Portuguese')
      return Services.subtypeofPERSONALTRAINERInBR;
    else
      return [];
  }

  navigateToBook1Page() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Book1(tasker, taskerId);
    }));
  }
}

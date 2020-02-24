import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:location/location.dart';

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

  CustomFirestore _customFirestore = new CustomFirestore();
  User _user = new User();

  final MarkerId mId = MarkerId('mylocation');

  //current location
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  static double zoomValue = 10;
  GeoPoint _geoPoint = new GeoPoint(30.3753, 69.3451);
  BitmapDescriptor mylocationIcon;

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
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/mylocation.png')
        .then((d) {
      mylocationIcon = d;
    });
    if (_user.geopoint != null) {
      _geoPoint = _user.geopoint;
      //user location marker start
      setMyLocationMarker();
      //user location marker end

      getUserLocation();
    } else {
      getCurrentLocation();
    }
    populateTaskers();
    super.initState();
  }

  setMyLocationMarker() {
    final Marker marker = Marker(
      markerId: mId,
      position: LatLng(_geoPoint.latitude, _geoPoint.longitude),
      infoWindow: InfoWindow(title: 'Your Location'),
      icon: mylocationIcon,
    );
    markers[mId] = marker;
  }

  getUserLocation() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.GRANTED) {
      _locationData = await location.getLocation();
      setState(() {
        _geoPoint =
            new GeoPoint(_locationData.latitude, _locationData.longitude);

        setMyLocationMarker();

        _newLocation = CameraPosition(
            // bearing: 192.8334901395799,
            target: LatLng(_geoPoint.latitude, _geoPoint.longitude),
            // tilt: 59.440717697143555,
            zoom: zoomValue);

        _goToNewLocation(_newLocation);
      });
    }
  }

  getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _geoPoint = new GeoPoint(_locationData.latitude, _locationData.longitude);

      _newLocation = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(_geoPoint.latitude, _geoPoint.longitude),
          // tilt: 59.440717697143555,
          zoom: zoomValue);

      _goToNewLocation(_newLocation);
    });
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
      infoWindow: InfoWindow(title: 'Name', snippet: request['taskername']),
    );

    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
          // Center(child: Text('center'),),
          GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        initialCameraPosition: CameraPosition(
            target: LatLng(_geoPoint.latitude, _geoPoint.longitude),
            zoom: zoomValue),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
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
}

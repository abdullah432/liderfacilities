import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  String language;
  //singleton logic
  static final Setting setting = Setting._internal();
  BitmapDescriptor myLocationIcon;
  GeoPoint _geoPoint;

  Setting._internal();
  factory Setting() {
    return setting;
  }

  void setLanguageToSP(String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('language', value);
    this.language = value;
    debugPrint('after setting to SP');
  }

  Future<String> getLanguageFromSP() async {
    final pref = await SharedPreferences.getInstance();
    language = pref.getString('language') ?? 'English';
    debugPrint('getL: ' + language);
    return language;
  }

  String getLanguage() {
    return language;
  }

  void loadMyLocationIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/mylocation.png')
        .then((d) {
      myLocationIcon = d;
    });
  }

  get getmyLocationIcon {
    return myLocationIcon;
  }

  // void loadLocation() async{
  //   _permissionGranted = await _location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.GRANTED) {
  //     _locationData = await _location.getLocation();
  //     _geoPoint = new GeoPoint(_locationData.latitude, _locationData.longitude);
  //   }
  //   else{
  //     _geoPoint = null;
  //   }
  // }

  // get defaultlocation {
  //   return _geoPoint;
  // }
}

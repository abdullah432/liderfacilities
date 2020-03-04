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
    debugPrint('language save in SP: '+value.toString());
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

  void getLocationFromSP() async{
    final pref = await SharedPreferences.getInstance();
    double lat = pref.getDouble('latitude') ?? 30.3753;
    double long = pref.getDouble('logitude') ?? 69.3451;
    _geoPoint = GeoPoint(lat,long);
  }

  void setLocationToSP(GeoPoint geoPoint) async{
    final pref = await SharedPreferences.getInstance();
    double lat = geoPoint.latitude;
    double long = geoPoint.longitude;
    pref.setDouble('latitude', lat);
    pref.setDouble('logitude', long);
    _geoPoint = geoPoint;
  }

  setLocation(GeoPoint geoPoint) {
    _geoPoint = geoPoint;
  }

  get location {
    return _geoPoint;
  }
}

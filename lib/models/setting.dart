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
  Color pColor = Color.fromRGBO(26, 119, 186, 1);
  Color taskerViewColor = Color.fromRGBO(255, 107, 107, 1);

  //when tasker home first time call then routecall will be falses
  bool routeCall = false;
  GeoPoint buyerLocation;

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
    language = pref.getString('language') ?? 'Portuguese';
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
    double lat = pref.getDouble('latitude') ?? -23.5352718;
    double long = pref.getDouble('logitude') ?? -46.6316168;
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

  setRouteState(value) {
    routeCall = value;
  }

  setRoute(value, GeoPoint geoPoint) {
    routeCall = value;
    buyerLocation = geoPoint;
  }

  get location {
    return _geoPoint;
  }

  get primaryColor {
    return pColor;
  }

  get routecall {
    return routeCall;
  }

  get buyerlocation {
    return buyerLocation;
  }
}

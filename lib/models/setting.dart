import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {

  String language;
    //singleton logic
  static final Setting setting = Setting._internal();
  Setting._internal();
  factory Setting() {
    return setting;
  }

  void setLanguageToSP(String value) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString('language', value);
    this.language = value;
    debugPrint('after setting to SP');
  }

  Future<String> getLanguageFromSP() async{
    final pref = await SharedPreferences.getInstance();
    language = pref.getString('language') ?? 'English';
    debugPrint('getL: '+language);
    return language;
  }

  String getLanguage(){
    return language;
  }
}
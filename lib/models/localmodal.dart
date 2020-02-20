import 'package:flutter/material.dart';

class LocaleModel with ChangeNotifier {
  Locale locale = Locale('en','US');
  Locale get getlocale => locale;
  void changelocale(Locale l) {
    locale = l;
    notifyListeners();
  }
}
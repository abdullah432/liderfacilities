import 'package:flutter/cupertino.dart';
import 'package:liderfacilites/models/app_localization.dart';

class CustomValidation {
    static String validatePassword(String valule, BuildContext context) {
    if (valule.length < 6) {
      return AppLocalizations.of(context)
          .translate('Your password need to be atleast 6 characters');
    } else
      return null;
  }
}
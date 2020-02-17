import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liderfacilites/models/auth_provider.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/rootpage.dart';

import 'models/app_localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
     static void setLocale(BuildContext context, Locale newLocale) async {
      MyAppState state =
           context.findAncestorStateOfType<MyAppState>();
        state.changeLanguage(newLocale);
     }
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp> {
  Setting setting = new Setting();
    Locale _locale;

   changeLanguage(Locale locale) {
     setState(() {
      _locale = locale;
     });
    }

    @override
  void initState() {
    setLanguage();
    super.initState();
  }

  setLanguage() async{
    String selectedLanguage = await setting.getLanguageFromSP();
    if (selectedLanguage == 'English'){
      setState(() {
              _locale = Locale('en', 'EN');
      });
      debugPrint('local: '+_locale.toString());
    }else {
            setState(() {
              _locale = Locale('pt', 'BR');
      });
       debugPrint('local: '+_locale.toString());
    }
  }
    
  @override
  Widget build(BuildContext context) {
    return AuthProvider(auth: Auth(), child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lider Facilities',
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        // Locale('br', 'BR'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }

          // if (supportedLocale.languageCode == locale?.languageCode ||
          //     supportedLocale.countryCode == locale?.countryCode) {
          //   return supportedLocale;
          // }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      // locale: Locale('pt', 'BR'),
      locale: _locale,
      home: RootPage(),
    ));
  }
}


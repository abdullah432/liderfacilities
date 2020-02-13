import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liderfacilites/screens/login.dart';

import 'models/app_localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lider Facilities',
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('br', 'BR'),
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Login();
        }));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 119, 186, 1),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: Container(
      height: 170.0,
      width: 170.0,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('assets/images/logo.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    ));
  }
}

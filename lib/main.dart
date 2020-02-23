import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/auth_provider.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/addservices.dart';
import 'package:liderfacilites/screens/editInfo.dart';
import 'package:liderfacilites/screens/home.dart';
import 'package:liderfacilites/screens/login.dart';
import 'package:liderfacilites/screens/rootpage.dart';
import 'package:liderfacilites/screens/userhome/fourth_page.dart';
import 'package:provider/provider.dart';
import 'package:liderfacilites/models/localmodal.dart';
import 'models/app_localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    MyAppState state = context.findAncestorStateOfType<MyAppState>();
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
  bool callFromEditPage = false;

  changeLanguage(Locale locale) {
    setState(() {
      callFromEditPage = true;
      _locale = locale;
    });
  }

  @override
  void initState() {
    setLanguage();
    super.initState();
  }

  setLanguage() async {
    String selectedLanguage = await setting.getLanguageFromSP();
    if (selectedLanguage == 'English') {
      setState(() {
        _locale = Locale('en', 'EN');
        // MyApp.setLocale(context, Locale('en', 'EN'));
      });
      debugPrint('local: ' + _locale.toString());
    } else {
      setState(() {
        _locale = Locale('pt', 'BR');
        // MyApp.setLocale(context, Locale('pt', 'BR'));
      });
      debugPrint('local: ' + _locale.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
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
          locale: _locale,
          // locale: Provider.of<LocaleModel>(context, listen: false).locale,
          home: getPage(),
        ));
  }

  getPage() {
    if (callFromEditPage){
      callFromEditPage = false;
      User user = new User();
      return HomePage(user.uid);
    }
    else {
      return RootPage();
    }
  }

}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          final bool isLoggedIn = snapshot.hasData;
          // String data = snapshot.data;
          // debugPrint('data: '+data.toString());
          return isLoggedIn ? HomePage(snapshot.data) : Login();
        }
        return _buildWaitingScreen(context);
        //should return splash screen here
      },
    );
  }

  Widget _buildWaitingScreen(BuildContext context) {
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


import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/auth_provider.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/models/icons.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/userhome/home.dart';
import 'package:liderfacilites/screens/login.dart';
import 'package:liderfacilites/screens/controlpanel.dart';
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
  CustomIcon icon = new CustomIcon();
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
    icon.loadAllIcons();
    setting.getLocationFromSP();
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
          debugPrint('auth change');
          // return isLoggedIn ? TaskerView() : Login();
          // return ControlPanel();
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



// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:stripe_payment/stripe_payment.dart';

// void main() {
//   runApp(new MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Token _paymentToken;
//   PaymentMethod _paymentMethod;
//   String _error;
//   final String _currentSecret = null; //set this yourself, e.g using curl
//   PaymentIntentResult _paymentIntent;
//   Source _source;

//   ScrollController _controller = ScrollController();

//   final CreditCard testCard = CreditCard(
//     number: '4000002760003184',
//     expMonth: 12,
//     expYear: 21,
//   );

//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   @override
//   initState() {
//     super.initState();

//     StripePayment.setOptions(
//         StripeOptions(publishableKey: "pk_test_hTtMDzqHYQp6R6NnFXroNpO9001VoFKriY", merchantId: "Test", androidPayMode: 'test'));
//   }

//   void setError(dynamic error) {
//     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
//     setState(() {
//       _error = error.toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         key: _scaffoldKey,
//         appBar: new AppBar(
//           title: new Text('Plugin example app'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.clear),
//               onPressed: () {
//                 setState(() {
//                   _source = null;
//                   _paymentIntent = null;
//                   _paymentMethod = null;
//                   _paymentToken = null;
//                 });
//               },
//             )
//           ],
//         ),
//         body: ListView(
//           controller: _controller,
//           padding: const EdgeInsets.all(20),
//           children: <Widget>[
//             RaisedButton(
//               child: Text("Create Source"),
//               onPressed: () {
//                 StripePayment.createSourceWithParams(SourceParams(
//                   type: 'ideal',
//                   amount: 1099,
//                   currency: 'eur',
//                   returnURL: 'example://stripe-redirect',
//                 )).then((source) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
//                   setState(() {
//                     _source = source;
//                   });
//                 }).catchError(setError);
//               },
//             ),
//             Divider(),
//             RaisedButton(
//               child: Text("Create Token with Card Form"),
//               onPressed: () {
//                 StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
//                   setState(() {
//                     _paymentMethod = paymentMethod;
//                   });
//                 }).catchError(setError);
//               },
//             ),
//             RaisedButton(
//               child: Text("Create Token with Card"),
//               onPressed: () {
//                 StripePayment.createTokenWithCard(
//                   testCard,
//                 ).then((token) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
//                   setState(() {
//                     _paymentToken = token;
//                   });
//                 }).catchError(setError);
//               },
//             ),
//             Divider(),
//             RaisedButton(
//               child: Text("Create Payment Method with Card"),
//               onPressed: () {
//                 StripePayment.createPaymentMethod(
//                   PaymentMethodRequest(
//                     card: testCard,
//                   ),
//                 ).then((paymentMethod) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
//                   setState(() {
//                     _paymentMethod = paymentMethod;
//                   });
//                 }).catchError(setError);
//               },
//             ),
//             RaisedButton(
//               child: Text("Create Payment Method with existing token"),
//               onPressed: _paymentToken == null
//                   ? null
//                   : () {
//                       StripePayment.createPaymentMethod(
//                         PaymentMethodRequest(
//                           card: CreditCard(
//                             token: _paymentToken.tokenId,
//                           ),
//                         ),
//                       ).then((paymentMethod) {
//                         _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
//                         setState(() {
//                           _paymentMethod = paymentMethod;
//                         });
//                       }).catchError(setError);
//                     },
//             ),
//             Divider(),
//             RaisedButton(
//               child: Text("Confirm Payment Intent"),
//               onPressed: _paymentMethod == null || _currentSecret == null
//                   ? null
//                   : () {
//                       StripePayment.confirmPaymentIntent(
//                         PaymentIntent(
//                           clientSecret: _currentSecret,
//                           paymentMethodId: _paymentMethod.id,
//                         ),
//                       ).then((paymentIntent) {
//                         _scaffoldKey.currentState
//                             .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
//                         setState(() {
//                           _paymentIntent = paymentIntent;
//                         });
//                       }).catchError(setError);
//                     },
//             ),
//             RaisedButton(
//               child: Text("Authenticate Payment Intent"),
//               onPressed: _currentSecret == null
//                   ? null
//                   : () {
//                       StripePayment.authenticatePaymentIntent(clientSecret: _currentSecret).then((paymentIntent) {
//                         _scaffoldKey.currentState
//                             .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
//                         setState(() {
//                           _paymentIntent = paymentIntent;
//                         });
//                       }).catchError(setError);
//                     },
//             ),
//             Divider(),
//             RaisedButton(
//               child: Text("Native payment"),
//               onPressed: () {
//                 if (Platform.isIOS) {
//                   _controller.jumpTo(450);
//                 }
//                 StripePayment.paymentRequestWithNativePay(
//                   androidPayOptions: AndroidPayPaymentRequest(
//                     total_price: "1.20",
//                     currency_code: "EUR",
//                   ),
//                   applePayOptions: ApplePayPaymentOptions(
//                     countryCode: 'DE',
//                     currencyCode: 'EUR',
//                     items: [
//                       ApplePayItem(
//                         label: 'Test',
//                         amount: '13',
//                       )
//                     ],
//                   ),
//                 ).then((token) {
//                   setState(() {
//                     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
//                     _paymentToken = token;
//                   });
//                 }).catchError(setError);
//               },
//             ),
//             RaisedButton(
//               child: Text("Complete Native Payment"),
//               onPressed: () {
//                 StripePayment.completeNativePayRequest().then((_) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Completed successfully')));
//                 }).catchError(setError);
//               },
//             ),
//             Divider(),
//             Text('Current source:'),
//             Text(
//               JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
//               style: TextStyle(fontFamily: "Monospace"),
//             ),
//             Divider(),
//             Text('Current token:'),
//             Text(
//               JsonEncoder.withIndent('  ').convert(_paymentToken?.toJson() ?? {}),
//               style: TextStyle(fontFamily: "Monospace"),
//             ),
//             Divider(),
//             Text('Current payment method:'),
//             Text(
//               JsonEncoder.withIndent('  ').convert(_paymentMethod?.toJson() ?? {}),
//               style: TextStyle(fontFamily: "Monospace"),
//             ),
//             Divider(),
//             Text('Current payment intent:'),
//             Text(
//               JsonEncoder.withIndent('  ').convert(_paymentIntent?.toJson() ?? {}),
//               style: TextStyle(fontFamily: "Monospace"),
//             ),
//             Divider(),
//             Text('Current error: $_error'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/auth_provider.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/addservices.dart';
import 'package:liderfacilites/screens/editInfo.dart';
import 'package:liderfacilites/screens/home.dart';
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

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class Destination {
//   const Destination(this.title, this.icon, this.color);
//   final String title;
//   final IconData icon;
//   final MaterialColor color;
// }

// const List<Destination> allDestinations = <Destination>[
//   Destination('Home', Icons.home, Colors.teal),
//   Destination('Business', Icons.business, Colors.cyan),
//   Destination('School', Icons.school, Colors.orange),
//   Destination('Flight', Icons.flight, Colors.blue)
// ];

// class RootPage extends StatelessWidget {
//   const RootPage({ Key key, this.destination }) : super(key: key);

//   final Destination destination;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(destination.title),
//         backgroundColor: destination.color,
//       ),
//       backgroundColor: destination.color[50],
//       body: SizedBox.expand(
//         child: InkWell(
//           onTap: () {
//             Navigator.pushNamed(context, "/list");
//           },
//         ),
//       ),
//     );
//   }
// }

// class ListPage extends StatelessWidget {
//   const ListPage({ Key key, this.destination }) : super(key: key);

//   final Destination destination;

//   @override
//   Widget build(BuildContext context) {
//     const List<int> shades = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(destination.title),
//         backgroundColor: destination.color,
//       ),
//       backgroundColor: destination.color[50],
//       body: SizedBox.expand(
//         child: ListView.builder(
//           itemCount: shades.length,
//           itemBuilder: (BuildContext context, int index) {
//             return SizedBox(
//               height: 128,
//               child: Card(
//                 color: destination.color[shades[index]].withOpacity(0.25),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context, "/text");
//                   },
//                   child: Center(
//                     child: Text('Item $index', style: Theme.of(context).primaryTextTheme.display1),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class TextPage extends StatefulWidget {
//   const TextPage({ Key key, this.destination }) : super(key: key);

//   final Destination destination;

//   @override
//   _TextPageState createState() => _TextPageState();
// }

// class _TextPageState extends State<TextPage> {
//   TextEditingController _textController;

//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController(
//       text: 'sample text: ${widget.destination.title}',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.destination.title),
//         backgroundColor: widget.destination.color,
//       ),
//       backgroundColor: widget.destination.color[50],
//       body: Container(
//         padding: const EdgeInsets.all(32.0),
//         alignment: Alignment.center,
//         child: TextField(controller: _textController),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
// }


// class DestinationView extends StatefulWidget {
//   const DestinationView({ Key key, this.destination }) : super(key: key);

//   final Destination destination;

//   @override
//   _DestinationViewState createState() => _DestinationViewState();
// }

// class _DestinationViewState extends State<DestinationView> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//           settings: settings,
//           builder: (BuildContext context) {
//             switch(settings.name) {
//               case '/':
//                 return RootPage(destination: widget.destination);
//               case '/list':
//                 return ListPage(destination: widget.destination);
//               case '/text':
//                 return TextPage(destination: widget.destination);
//             }
//           },
//         );
//       },
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         child: IndexedStack(
//           index: _currentIndex,
//           children: allDestinations.map<Widget>((Destination destination) {
//             return DestinationView(destination: destination);
//           }).toList(),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (int index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: allDestinations.map((Destination destination) {
//           return BottomNavigationBarItem(
//             icon: Icon(destination.icon),
//             backgroundColor: destination.color,
//             title: Text(destination.title)
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(home: HomePage()));
// }
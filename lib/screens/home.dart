import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/screens/userhome/first_page.dart';
import 'package:liderfacilites/screens/userhome/second_page.dart';
import 'package:liderfacilites/screens/userhome/third_page.dart';
import 'package:liderfacilites/screens/userhome/fourth_page.dart';

class HomePage extends StatefulWidget {
  final useruid;
  HomePage(this.useruid);
  @override
  _HomePageState createState() => _HomePageState(useruid);
}

class _HomePageState extends State<HomePage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  var useruid;
  _HomePageState(this.useruid);

  //
  final db = Firestore.instance;
  //user record
  User userRecord;

  List<Widget> pages = [
    FirstPage(
      key: PageStorageKey('Page1'),
    ),
    SecondPage(
      key: PageStorageKey('Page2'),
    ),
    ThirdPage(
      key: PageStorageKey('Page3'),
    ),
    FourthPage(key: PageStorageKey('Page4')),
    Center(child: Text('Switch')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  @override
  void initState() {
    loadCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('homepage');
    debugPrint('uid' + useruid);
        // updateUserData(snapshot.data);
        return Scaffold(body: Stack(children: <Widget>[
          bodycontent(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomNaviationBar,
          )
        ]));

  }

  bodycontent() {
    return Container(
      child: pages[_selectedIndex],
    );
  }

  Widget get bottomNaviationBar {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        child: Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.white,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                      color: Colors
                          .white))), // sets the inactive color of the `BottomNavigationBar`
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.explore,
                  size: 32,
                  color: getColor(0),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('Explore'),
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  size: 30,
                  color: getColor(1),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('Booking'),
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  size: 30,
                  color: getColor(2),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('Saved'),
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: 30, color: getColor(3)),
                title: Text(
                  AppLocalizations.of(context).translate('Account'),
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.swap_horizontal_circle,
                  size: 30,
                  color: getColor(4),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('Switch'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getColor(int index) {
    if (index == _selectedIndex) {
      return Colors.blue;
    } else {
      return Colors.black38;
    }
  }

  // updateUserData(DocumentSnapshot snapshot) async {
  //     debugPrint('before');
  //     userRecord = User.fromSnapshot(snapshot);
  //     User user = new User();
  //     user.setUID(useruid);
  //     user.setname(userRecord.name);
  //     user.setEmail(userRecord.email);
  //     user.setPhoneNum(userRecord.phoneNumber);
  //     user.setUserState(userRecord.isTasker);
  //     if (userRecord.imageUrl != null)
  //       user.setImageUrl(userRecord.imageUrl);
  // }

  loadCurrentUserData() async {
    await db
        .collection('users')
        .document(useruid)
        .get()
        .then((DocumentSnapshot snapshot) {
      debugPrint('before');
      userRecord = User.fromSnapshot(snapshot);
      User user = new User();
      user.setUID(useruid);
      user.setname(userRecord.name);
      user.setEmail(userRecord.email);
      user.setPhoneNum(userRecord.phoneNumber);
      user.setUserState(userRecord.isTasker);
      debugPrint('us: '+userRecord.isTasker.toString());
      if (userRecord.imageUrl != null)
        user.setImageUrl(userRecord.imageUrl);
    });
  }
}

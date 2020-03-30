import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/screens/taskerhome/taskernav.dart';
import 'package:liderfacilites/screens/userhome/first_page.dart';
import 'package:liderfacilites/screens/userhome/second_page.dart';
import 'package:liderfacilites/screens/userhome/third_page.dart';
import 'package:liderfacilites/screens/userhome/fourth_page.dart';
import 'package:stripe_payment/stripe_payment.dart';

class HomePage extends StatefulWidget {
  final useruid;
  HomePage(this.useruid);
  @override
  _HomePageState createState() => _HomePageState(useruid);
}

class _HomePageState extends State<HomePage> {
  var useruid;
  _HomePageState(this.useruid);

//   //
  final db = Firestore.instance;
  //user record
  User _userRecord;

  //messaging
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_hTtMDzqHYQp6R6NnFXroNpO9001VoFKriY",
        merchantId: "Test",
        androidPayMode: 'test'));

    //messages
    _saveDeviceToken();
    getMessage();
  }

  _saveDeviceToken() async {
    // Get the current user
    // String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(useruid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        // 'createdAt': FieldValue.serverTimestamp(), // optional
        // 'platform': Platform.operatingSystem // optional
      });
    }
  }

  getMessage() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () => null,
        //   ),
        // );

        // Scaffold.of(context).showSnackBar(snackbar);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  updateUserData(DocumentSnapshot snapshot) async {
    debugPrint('update user data');
    _userRecord = User.fromSnapshot(snapshot);
    User user = new User();
    user.setUID(useruid);
    user.setname(_userRecord.name);
    user.setEmail(_userRecord.email);
    user.setPhoneNum(_userRecord.phoneNumber);
    user.setUserState(_userRecord.isTasker);
    if (_userRecord.imageUrl != null) user.setImageUrl(_userRecord.imageUrl);
    if (_userRecord.socialsecurity != null)
      user.setSocialSecurity(_userRecord.socialsecurity);
    if (_userRecord.socialsecuritynumber != null)
      user.setSocialSecurityNumber(_userRecord.socialsecuritynumber);
    if (_userRecord.reg != null) user.setReg(_userRecord.reg);
    if (_userRecord.address != null) user.setAddress(_userRecord.address);
    if (_userRecord.geopoint != null) user.setGeoPoint(_userRecord.geopoint);
    if (_userRecord.favoriteList != null)
      user.setFavouriteList(_userRecord.favoriteList);
    if (_userRecord.bookingList != null)
      user.setBookingList(_userRecord.bookingList);
    if (_userRecord.requestList != null)
      user.setRequestList(_userRecord.requestList);
  }

  final List<Widget> pages = [
    FirstPage(
      key: PageStorageKey('Page1'),
    ),
    SecondPage(
      key: PageStorageKey('Page2'),
    ),
    ThirdPage(
      key: PageStorageKey('Page3'),
    ),
    FourthPage(
      key: PageStorageKey('Page4'),
    ),
    Center(child: Text('Switch')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;
  CustomFirestore _customFirestore = new CustomFirestore();

  Widget _bottomNavigationBar() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(useruid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              if (snapshot.hasData) {
                updateUserData(snapshot.data);
                _customFirestore.checkBookingTiming();
              }
              return PageStorage(
                child: pages[_selectedIndex],
                bucket: bucket,
              );
            }));
  }

  getColor(int index) {
    if (index == _selectedIndex) {
      return Colors.blue;
    } else {
      return Colors.black38;
    }
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      if (_userRecord.isTasker) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return TaskerView();
        }));
      } else {
        showBecomeTaskerAlert();
      }
    } else {
      setState(() {
        _selectedIndex = index;
        // if (index == 1) _navigatorKey.currentState.pushNamed('/page2');
        // if (index == 2) _navigatorKey.currentState.pushNamed('/page3');
        // if (index == 3) _navigatorKey.currentState.pushNamed('/page4');
      });
    }
  }

  showBecomeTaskerAlert() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .translate('You are not a Tasker')),
              content: Text(AppLocalizations.of(context)
                  .translate('Go to Account and become a tasker')),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: Text('OK'),
                ),
              ],
            ));
  }
}

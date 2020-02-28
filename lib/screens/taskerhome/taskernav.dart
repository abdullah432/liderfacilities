import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/screens/taskerhome/tasker_homepage.dart';
import 'package:liderfacilites/screens/userhome/second_page.dart';
import 'package:liderfacilites/screens/userhome/third_page.dart';

class TaskerView extends StatefulWidget {
  @override
  _TaskerViewState createState() => _TaskerViewState();
}

class _TaskerViewState extends State<TaskerView> {
  final List<Widget> pages = [
    TaskerHome(
      key: PageStorageKey('taskerhomepage'),
    ),
    SecondPage(
      key: PageStorageKey('Page2'),
    ),
    ThirdPage(
      key: PageStorageKey('Page3'),
    ),
    Center(child: Text('Switch')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

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
                  'Home',
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
                  AppLocalizations.of(context).translate('Earning'),
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
                  AppLocalizations.of(context).translate('History'),
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.swap_horizontal_circle,
                  size: 30,
                  color: getColor(3),
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
    // debugPrint('selected index: ' + _selectedIndex.toString());
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: PageStorage(
          child: pages[_selectedIndex],
          bucket: bucket,
        ));
    // StreamBuilder(
    //     stream: Firestore.instance
    //         .collection('users')
    //         .document(useruid)
    //         .snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) return SplashScreen();

    //       // final record = User.fromSnapshot(snapshot.data);
    //       updateUserData(snapshot.data);
    //       return PageStorage(
    //         child: pages[_selectedIndex],
    //         bucket: bucket,
    //       );
    //     }));
  }

  getColor(int index) {
    if (index == _selectedIndex) {
      return Color.fromRGBO(255, 107, 107, 1);
    } else {
      return Colors.black38;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  showBecomeTaskerAlert() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('You are not a Tasker'),
              content: Text('Go to Account and become a tasker'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    //nothing
                  },
                  child: Text('OK'),
                ),
              ],
            ));
  }
}

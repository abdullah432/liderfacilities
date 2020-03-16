import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/booking.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/screens/chatroom/chat.dart';
import 'package:intl/intl.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SecondPageState();
  }
}

class SecondPageState extends State<SecondPage> {
  AppLocalizations lang;
  // List<String> favouriteList;
  bool favEmpty = true;
  User _user = new User();
  List<String> _listOfbooking;
  List<Booking> _bookingList = new List();
  CustomFirestore _customFirestore = new CustomFirestore();
  String _imageUrl;

  @override
  void initState() {
    _listOfbooking = _user.bookingList;

    if (_listOfbooking?.isEmpty ?? true) {
      favEmpty = true;
    } else {
      favEmpty = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context);
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          uperPart(),
          searchTF(),
          favEmpty == true
              ? Center(
                  child: Text('No Booking'),
                )
              : 
              FutureBuilder(
                  future: _customFirestore.loadBooking(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0)
                        return Center(
                          child: Text('No Booking'),
                        );
                      else
                        return Transform.translate(
                            offset: Offset(0, -25),
                            child: SingleChildScrollView(
                                child: _buildList(context, snapshot.data)));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
        ],
      ),
    ));
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.5,
      decoration: BoxDecoration(
          color: Color.fromRGBO(26, 119, 186, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Lider Facilities',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19),
              ))),
    );
  }

  searchTF() {
    return Transform.translate(
        offset: Offset(0, -25),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                padding: EdgeInsets.only(left: 20, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
                child: Row(children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  Flexible(
                      child: TextFormField(
                    // textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        // hintText: 'Email',
                        hintText: lang.translate('Search'),
                        border: InputBorder.none,
                        fillColor: Colors.blue),
                  )),
                ]),
              )
            ],
          ),
        ));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        )
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    print('before');
    final record = Booking.fromSnapshot(data);
    _imageUrl = record.taskerimageurl;
    print(_imageUrl);

    return Padding(
        // key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      // backgroundColor: Colors.black,
                      child: ClipOval(
                          child: _imageUrl == null
                              ? Image.asset(
                                  'assets/images/account.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.network(
                                  _imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )),
                    ),
                    title: Text(
                      record.taskername,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  record.type,
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  record.subtype,
                                )),
                          ],
                        )),
                    trailing: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2)),
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () {
                              //todo tasker chat page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chat(
                                            peerId: record.bookby,
                                            peerAvatar: _imageUrl,
                                            peername: record.taskername,
                                          )));
                            },
                            child: Icon(
                              Icons.message,
                              color: Colors.blue,
                              size: 17,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 12, top: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            readTimestamp(record.timestamp),
                            // style: TextStyle(color: Colors.green),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('State: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(record.state, style: getStyle(record.state)),
                          )
                        ],
                      ))
                ],
              ),
            )));
  }

  getStyle(style) {
    switch(style) {
      case 'Waiting for tasker response':
        return TextStyle(color: Colors.green);
        break;
      case 'Tasker fail to respond':
        return TextStyle(color: Colors.red);
        break;
    }
  }

  readTimestamp(timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}

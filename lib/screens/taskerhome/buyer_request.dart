import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/requests.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/chatroom/chat.dart';
import 'package:liderfacilites/screens/taskerhome/taskernav.dart';

class BuyerRequest extends StatefulWidget {
  const BuyerRequest({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BuyerRequestState();
  }
}

class BuyerRequestState extends State<BuyerRequest> {
  AppLocalizations lang;
  // List<String> favouriteList;
  bool requestEmpty = true;
  User _user = new User();
  List<String> _listOfRequest;
  // List<Service> _favouriteServices = new List();
  CustomFirestore _customFirestore = new CustomFirestore();
  String _imageUrl;
  Setting setting = new Setting();

  @override
  void initState() {
    _listOfRequest = _user.requestList;

    if (_listOfRequest?.isEmpty ?? true) {
      requestEmpty = true;
    } else {
      requestEmpty = false;
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
          requestEmpty == true
              ? Center(
                  child: Text('No Request'),
                )
              : FutureBuilder(
                  future: _customFirestore.loadAllRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0)
                        return Center(
                          child: Text('No Request'),
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
          // StreamBuilder(stream: Firestore.instance.collection(path).g,)
        ],
      ),
    ));
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.5,
      decoration: BoxDecoration(
          color: setting.taskerViewColor,
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
    final record = Request.fromSnapshot(data);
    _imageUrl = record.buyerimageurl;

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
                    title: Text(record.buyername),
                    subtitle: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  record.type,
                                  // 'Type1'
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  record.subtype,
                                  // 'Type 2',
                                )),
                          ],
                        )),
                    trailing: requiredWidget(record),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          requiredTextWidget(record),
                          Spacer(),
                          Text(
                            '${record.price} \$',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                print('chat');
                                navigateToChatRoom(record);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.message,
                                  color: setting.pColor,
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                print('line between tasker and buyer');
                                GeoPoint buyerLoc = record.geopoint;
                                setting.setRoute(true, buyerLoc);
                                navigateToTaskerHomePage();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  Icons.directions,
                                  color: setting.pColor,
                                ),
                              )),
                        ],
                      )),
                ],
              )),
        ));
  }

  requiredWidget(Request record) {
    return record.state == 'Waiting for tasker response'
        ? Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2)),
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        print('cancel');
                        _customFirestore
                            .cancelRequest(record.reference.documentID);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 17,
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2)),
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        print('accept');
                        _customFirestore
                            .acceptRequest(record.reference.documentID);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 17,
                      ),
                    )),
              ),
            ),
          ])
        : Container(width: 0, height: 0);
  }

  requiredTextWidget(record) {
    Widget widget;
    if (record.state == 'Waiting for tasker response')
      widget = Text('New', style: TextStyle(color: Colors.green));
    else if (record.state == 'Accepted')
      widget = Text('Accepted', style: TextStyle(color: Colors.green));
    else
      widget = Text(record.state, style: TextStyle(color: Colors.red));

    return widget;
  }

  navigateToChatRoom(Request record) {
    //we need user id not service id
    // DocumentReference docRef = record.bookby;
    //todo tasker chat page
    print('navigate to chage page');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  peerId: record.bookby,
                  peerAvatar: record.taskerimageurl,
                  peername: record.buyername,
                )));
  }

  navigateToTaskerHomePage() {
    Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return TaskerView();
        }));
  }
}

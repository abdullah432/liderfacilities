import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/setting.dart';

class ControlPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ControlPanelState();
  }
}

class ControlPanelState extends State<ControlPanel> {
  Setting setting = new Setting();
  int selectedcat = 0;
  Widget selectedWidget;
  CustomFirestore _customFirestore = new CustomFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Panel'),
      ),
      body: Column(
        children: <Widget>[
          listOfCategory(),
          showResultPart(),
        ],
      ),
    );
  }

  listOfCategory() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedcat == 1) {
                    selectedcat = 0;
                    selectedWidget = null;
                  } else {
                    selectedcat = 1;
                    selectedWidget = allUsersData();
                  }
                });
              },
              child: Card(
                color: selectedcat == 1 ? setting.pColor : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    'All Users',
                    style: TextStyle(
                      color: selectedcat == 1 ? Colors.white : setting.pColor,
                    ),
                  )),
                ),
              ),
            ),
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              setState(() {
                if (selectedcat == 2) {
                  selectedcat = 0;
                  selectedWidget = null;
                } else {
                  selectedcat = 2;
                  selectedWidget = allTaskersData();
                }
              });
            },
            child: Card(
              color: selectedcat == 2 ? setting.pColor : Colors.white,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'All Taskers',
                        style: TextStyle(
                          color:
                              selectedcat == 2 ? Colors.white : setting.pColor,
                        ),
                      ))),
            ),
          )),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedcat == 3) {
                      selectedcat = 0;
                      selectedWidget = null;
                    } else {
                      selectedcat = 3;
                      selectedWidget = allOrdersData();
                    }
                  });
                },
                child: Card(
                  color: selectedcat == 3 ? setting.pColor : Colors.white,
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'All Orders',
                            style: TextStyle(
                              color: selectedcat == 3
                                  ? Colors.white
                                  : setting.pColor,
                            ),
                          ))),
                )),
          ),
        ],
      ),
    );
  }

  showResultPart() {
    // selectedWidget = circularProgressIndicator();
    // selectedWidget = allUsersData();
    return selectedWidget != null
        ? selectedWidget
        : Container(
            width: 0,
            height: 0,
          );
  }

  circularProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  allUsersData() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // if (!snapshot.hasData) return new Text("There is no User");
          if (snapshot.connectionState == ConnectionState.waiting)
            return circularProgressIndicator();
          else if (snapshot.connectionState == ConnectionState.none)
            return new Text("There is no User");

          return new ListView(
              shrinkWrap: true, children: getUserName(snapshot));
        });
  }

  getUserName(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new ListTile(title: new Text(doc["name"])))
        .toList();
  }

  allTaskersData() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("users")
              .where('istasker', isEqualTo: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if (!snapshot.hasData) return new Text("There is no User");
            if (snapshot.connectionState == ConnectionState.waiting)
              return circularProgressIndicator();
            else if (snapshot.connectionState == ConnectionState.none)
              return new Text("There is no Tasker");

            return new ListView(
                shrinkWrap: true, children: generateTaskerList(snapshot));
          }),
    );
  }

  generateTaskerList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new ListTile(title: new Text(doc["name"])))
        .toList();
  }

  allOrdersData() {
    return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("book").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // if (!snapshot.hasData) return new Text("There is no User");
              if (snapshot.connectionState == ConnectionState.waiting)
                return circularProgressIndicator();
              else if (snapshot.connectionState == ConnectionState.none)
                return new Text("There is no Order");

              return Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Column(children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text(
                        'Buyer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      Expanded(child: Text(
                        'Tasker',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                  ListView(
                      shrinkWrap: true, children: generateOrderList(snapshot))
                ]),
              );
            }));
  }

  generateOrderList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text(doc['buyername'])),
                Expanded(child: Text(doc['taskername'])),
              ],
            ))
        .toList();
  }
}

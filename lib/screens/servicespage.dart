import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/Service.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/screens/addservices.dart';
import 'package:liderfacilites/screens/editservice.dart';

class MyServices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyServicesState();
  }
}

class MyServicesState extends State<MyServices> {
  User user = new User();
  String _imageUrl;

  //reference of current user services
  DocumentReference docRef;
  var db = Firestore.instance;

  //custom firestore
  CustomFirestore _customFirestore = new CustomFirestore();

  @override
  Widget build(BuildContext context) {
    docRef = db.collection('users').document(user.uid);
    if (user.uid != null) debugPrint('useruid: ' + user.uid);
    debugPrint('reference: ' + docRef.path);
    return Scaffold(
        body: SingleChildScrollView(
      child: _buildBody(context),
    )
        // myServiceBody(context)
        );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream: Firestore.instance.collection('services').snapshots(),
      stream: Firestore.instance
          .collection('services')
          .where('reference', isEqualTo: docRef)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return noServiceBody(context);
        if (snapshot.hasData) {
          // debugPrint('data length: '+snapshot.data.documents.toList().length.toString());
          if (snapshot.data.documents.length == 0)
            return noServiceBody(context);
          else
            return SingleChildScrollView(
                child: _buildList(context, snapshot.data.documents));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: <Widget>[
        uperPart(),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 20.0),
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        )
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Service.fromSnapshot(data);
    _imageUrl = record.imageurl;

    return Padding(
        // key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        // backgroundColor: Colors.black,
                        child: ClipOval(
                            child: _imageUrl == null
                                ? Image.asset(
                                    'assets/images/account.png',
                                  )
                                : Image.network(
                                    _imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                      ),
                      title: Text(record.name),
                      subtitle: Text(
                        record.description,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        // decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     border: Border.all(color: Colors.blue, width: 2)),
                        child: Text('${record.hourlyrate} R\$'),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0, right: 5),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      //edit service
                      GestureDetector(
                        onTap: () {
                          //edit service
                          print('edit');
                          Navigator.push(
                            context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => EditService(data.documentID, record),
                              )
                          );

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                      //delete service
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            //delete service
                            print('doc: ' + data.documentID.toString());
                            _customFirestore.deleteService(data.documentID);
                            setState(() {

                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.blue,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  // myServiceBody(BuildContext context) {
  //   if (!user.isTasker) {
  //     return noServiceBody(context);
  //   } else {
  //     //todo
  //     return servicesBody(context);
  //   }
  // }

  noServiceBody(BuildContext context) {
    return Column(
      children: <Widget>[
        uperPart(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.height / 3.2,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: new AssetImage('assets/images/noservice.png'),
                // fit: BoxFit.fill
              ),
              shape: BoxShape.circle,
            ),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
              child: Text(
                  AppLocalizations.of(context)
                      .translate("You don't have any service"),
                  style: TextStyle(fontSize: 18))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Center(
              child: Text(
                  AppLocalizations.of(context).translate(
                      "If you wanna add a new one you have to be a tasker first"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: RaisedButton(
            onPressed: () {
              // debugPrint('become tasker');
              navigateToAddServicePage();
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Color.fromRGBO(26, 119, 186, 1),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10),
              child: Text(
                AppLocalizations.of(context).translate('Become a tasker'),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  servicesBody(BuildContext context) {
    return Column(
      children: <Widget>[
        uperPart(),
        Card(
            child: ListTile(
          onTap: () {
            print('dlick');
          },
          leading: CircleAvatar(
            radius: 28,
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
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )),
          ),
          title: Text('Title'),
          subtitle: Text('Subtitle'),
          trailing: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black38, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Expanded(child: Text('40 \$')),
            ),
          ),
        )),
      ],
    );
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
          color: Color.fromRGBO(26, 119, 186, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(AppLocalizations.of(context).translate('My Services'),
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                // if (!user.isTasker) navigateToAddServicePage();
                navigateToAddServicePage();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(AppLocalizations.of(context).translate('Add New'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  navigateToAddServicePage() async {
    bool result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddService(),
      ),
    );

    if (result) {
      if (this.mounted) {
        setState(() {
          // user.setUserState(true);
          debugPrint('service page setstate: return from adding new service');
        });
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/Service.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/screens/chatroom/chat.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ThirdPageState();
  }
}

class ThirdPageState extends State<ThirdPage> {
  AppLocalizations lang;
  // List<String> favouriteList;
  bool favEmpty = true;
  User _user = new User();
  List<String> _listOfFav;
  // List<Service> _favouriteServices = new List();
  CustomFirestore _customFirestore = new CustomFirestore();
  String _imageUrl;

  @override
  void initState() {
    _listOfFav = _user.favoriteList;
    print(_listOfFav);
    // if (_favouriteServices.isEmpty && _favouriteServices != null) {
    //   favEmpty = true;
    //   debugPrint('data true');
    // } else {
    //   favEmpty = false;
    // }
    if (_listOfFav?.isEmpty ?? true) {
      favEmpty = true;
    } else {
      favEmpty = false;
    }
    super.initState();
  }

  // loadFavServices() async {
  //   for (int i = 0; i < favouriteList.length; i++) {
  //     debugPrint('serviceid: ' + favouriteList[i].toString());
  //     Service service =
  //         await _customFirestore.loadFavServices(favouriteList[i]);
  //     debugPrint('before');
  //     _favouriteServices.add(service);
  //   }
  //   debugPrint('lenghtofser: ' + _favouriteServices.length.toString());
  //   // debugPrint('services: '+_favouriteServices.toString());
  //   if (this.mounted){
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

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
                  child: Text(lang.translate('No Favorite Services')),
                )
              : FutureBuilder(
                  future: _customFirestore.loadFavServices(),
                  builder: (context, snapshot) {
                    // if (!snapshot.hasData)
                    //   return Center(
                    //     child: Text('No Favourite Service'),
                    //   );
                      if (snapshot.hasData) {
                        // debugPrint('data length: '+snapshot.data.documents.toList().length.toString());
                        if (snapshot.data.length == 0)
                          return Center(
                            child: Text(lang.translate('No Favorite Services')),
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
    final record = Service.fromSnapshot(data);
    _imageUrl = record.imageurl;

    return Padding(
        // key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
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
              title: Text(record.name),
              subtitle: Text(
                record.description,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
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
                                            peerId: record.docReference.documentID,
                                            peerAvatar: _imageUrl,
                                            peername: record.name,
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
          ),
        ));
  }
}

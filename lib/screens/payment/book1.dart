import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:geolocator/geolocator.dart';

import 'makePayment.dart';

class Book1 extends StatefulWidget {
  final _taskerData;
  final _taskerID;
  Book1(this._taskerData, this._taskerID);
  @override
  State<StatefulWidget> createState() {
    return Book1State(_taskerData, _taskerID);
  }
}

class Book1State extends State<Book1> {
  var _taskerData;
  var _taskerID;
  Book1State(this._taskerData, this._taskerID);

  MediaQueryData mediaQuery;
  AppLocalizations lang;
  //user location
  Geolocator geolocator = Geolocator();
  Position userLocation;
  //service data
  var listOfSubServices = [];
  String taskername;
  String taskerAddress;
  String servicePrice;
  String profileImgUrl;
  String serviceImgUrl;

  @override
  void initState() {
    listOfSubServices.add(_taskerData['type']);
    listOfSubServices.add(_taskerData['subtype']);
    taskername = _taskerData['taskername'];
    servicePrice = _taskerData['hourlyrate'];
    taskerAddress = _taskerData['address'];
    profileImgUrl = _taskerData['imgurl'];

    // print('pro: ' + profileImgUrl);
    if (_taskerData['serviceimageurl'] != null){
      serviceImgUrl = _taskerData['serviceimageurl'];
    // print('ser: ' + serviceImgUrl);
    // print('called');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    lang = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        new Container(
          height: mediaQuery.size.height / 3,
          width: double.infinity,
          child: serviceImgUrl == null
              ? profileImgUrl == null
                  ? AssetImage("assets/images/placeholder.jpg")
                  : FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/placeholder.jpg'),
                      image: NetworkImage(
                        profileImgUrl,
                      ),
                    )
              : FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/placeholder.jpg'),
                  image: NetworkImage(
                    serviceImgUrl,
                  ),
                ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            leading: IconButton(
              tooltip: 'back button',
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: new Text(taskername),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Padding(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 5.5),
              child: Container(
                height: double.infinity,
                color: Color.fromRGBO(245, 245, 245, 1),
                child: detailView(),
              )),
        ),
      ],
    );
  }

  detailView() {
    return Transform.translate(
        offset: Offset(0, -20),
        child: SingleChildScrollView(
            child: Center(
          child: Container(
              width: mediaQuery.size.width / 1.1,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                    ),
                  ]),
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      namePriceRow(),
                      SizedBox(height: 8.0),
                      ratingBar(),
                      Divider(
                        height: 30,
                      ),
                      locationbox(),
                      Divider(
                        height: 30,
                      ),
                      servicesView(),
                      bookFeedbackBtn(),
                    ],
                  ))),
        )));
  }

  namePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          taskername,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '$servicePrice R\$',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  ratingBar() {
    return Align(
        alignment: Alignment.topLeft,
        child: RatingBar(
          initialRating: 4,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          glow: false,
          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ));
  }

  locationbox() {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
        child: Container(
            width: MediaQuery.of(context).size.width / 1.25,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.add_location,
                        color: Colors.black38,
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        taskerAddress == null
                            ? 'Unknown Address'
                            : taskerAddress,
                        style: TextStyle(fontSize: 9, color: Colors.black38),
                      ),
                    )
                  ]),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset('assets/images/location.png',
                      width: MediaQuery.of(context).size.width / 1.25,
                      height: MediaQuery.of(context).size.width / 3.5,
                      fit: BoxFit.cover),
                ),
              ],
            )));
  }

  servicesView() {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              lang.translate('Services'),
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: getServicesList()),
        )
      ],
    );
  }

  getServicesList() {
    List<Widget> widgets = [];

    for (int i = 0; i < listOfSubServices.length; i++) {
      widgets.add(Text(listOfSubServices[i],
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          )));
    }
    return widgets;
  }

  bookFeedbackBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Container(
          // height: 50,
          // width: MediaQuery.of(context).size.width / 1.25,
          child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 8,
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.black54)),
                onPressed: () {},
                child: Text(
                  lang.translate('Feedback'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.blueAccent),
                ),
              )),
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 8,
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Color.fromRGBO(26, 119, 186, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  navigateToPaymentPage();
                },
                child: Text(
                  lang.translate('Book'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white),
                ),
              )),
        ],
      )),
    );
  }

  navigateToPaymentPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MakePayment(_taskerData, _taskerID);
    }));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/utils.dart';
import 'package:liderfacilites/screens/payment/payment_card.dart';
import 'package:liderfacilites/screens/payment/payment.dart';

class MakePayment extends StatefulWidget {
  final _taskerData;
  final _taskerID;
  MakePayment(this._taskerData, this._taskerID);

  @override
  State<StatefulWidget> createState() {
    return MakePaymentState(_taskerData, _taskerID);
  }
}

class MakePaymentState extends State<MakePayment> {
  var _taskerData;
  var _taskerID;
  MakePaymentState(this._taskerData, this._taskerID);
  String servicetype;
  String taskername;
  String servicesubtype;
  String servicePrice;
  String taskerImgUrl;

  MediaQueryData mediaQuery;
  AppLocalizations lang;

  User _user = new User();

  //gap size from border
  double gapFromBorder;

  //styles
  TextStyle boldAlign = TextStyle(fontWeight: FontWeight.bold);
  //textboxes controllers
  TextEditingController nameC = TextEditingController();
  TextEditingController cardNumC = TextEditingController();
  TextEditingController expiryDateC = TextEditingController();
  TextEditingController cvvC = TextEditingController();

  //prompt visibilty
  bool promptVisibility = false;
  //by default no card is selected
  Color cardBgColor = Colors.white;
  List<ListTileSelection> selectionList = [];
  //firestore
  Firestore db = Firestore.instance;
  CustomFirestore _customF = new CustomFirestore();

  @override
  void initState() {
    taskername = _taskerData['taskername'];
    servicePrice = _taskerData['hourlyrate'];
    servicetype = _taskerData['type'];
    servicesubtype = _taskerData['subtype'];
    taskerImgUrl = _taskerData['imgurl'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    gapFromBorder = mediaQuery.size.width / 1.1;
    lang = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        new Container(
            height: double.infinity,
            width: double.infinity,
            color: Color.fromRGBO(245, 245, 245, 1)),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              leading: IconButton(
                tooltip: 'back button',
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(26, 119, 186, 1),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: new Text(
                "Payment",
                style: TextStyle(
                  color: Color.fromRGBO(26, 119, 186, 1),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
                child: Container(
              // height: double.infinity,
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    detailView(),
                    payBookBtn(),
                  ],
                ),
              ),
            ))),
        showPrompt(),
      ],
    );
  }

  detailView() {
    return Center(
      child: Container(
          width: gapFromBorder,
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
                  left: 20, right: 20, top: 25, bottom: 15),
              child: Column(
                children: <Widget>[
                  title1(),
                  alreadyAddedCardView(),
                  Divider(
                    height: 50,
                  ),
                  title2(),
                  nameTextBox(),
                  cardnumberTextBox(),
                  expiryCvvTextBox(),
                ],
              ))),
    );
  }

  title1() {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          lang.translate('Saved Card'),
          style: boldAlign,
        ));
  }

  alreadyAddedCardView() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(_user.uid)
          .collection('payment')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Visibility(
              visible: false, child: Container(width: 0.0, height: 0.0));

          // return Container(width: 0.0, height: 0.0);
        }
        if (snapshot.hasData) {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    for (int i = 0; i < snapshot.length; i++) {
      selectionList.add(ListTileSelection(snapshot[i].documentID));
    }
    return Column(
      children: <Widget>[
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
    final _record = Payment.fromSnapshot(data);

    // _getCardTypeFrmNumber(_record.cardnumber);
    String _cardnumber = _record.cardnumber;
    CardType cardType = CardUtils.getCardTypeFrmNumber(_cardnumber);
    // print('card number: ' + _cardnumber);

    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
                color: cardBgColor,
                child: ListTile(
                    selected: getListTileSelection(data.documentID),
                    leading: Icon(Icons.check_circle),
                    trailing: SizedBox(
                      width: 90,
                      child: Row(
                        children: <Widget>[
                          Text(_cardnumber.substring(0, 4)),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: CardUtils.getCardIcon(cardType),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(data.documentID);
                      for (int i = 0; i < selectionList.length; i++) {
                        if (selectionList[i].doucumentID == data.documentID) {
                          if (selectionList[i].isSelected) {
                            setState(() {
                              selectionList[i].isSelected = false;
                            });
                          } else {
                            setState(() {
                              selectionList[i].isSelected = true;
                            });
                          }
                        } else {
                          selectionList[i].isSelected = false;
                        }
                        //above logic work fine for multiple selection. but if we want to unselect other when one is selected

                      }
                    }))
          ],
        ));
  }

  getListTileSelection(id) {
    for (int i = 0; i < selectionList.length; i++) {
      if (selectionList[i].doucumentID == id) {
        if (selectionList[i].isSelected)
          return true;
        else
          return false;
      }
    }
  }

  title2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            lang.translate('Add New Card'),
            style: boldAlign,
          )),
    );
  }

  nameTextBox() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12)]),
            child: TextFormField(
              keyboardType: TextInputType.text,
              validator: validate,
              controller: nameC,
              decoration: InputDecoration(
                  hintText: lang.translate('Name on Card'),
                  border: InputBorder.none,
                  fillColor: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  cardnumberTextBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12)]),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: validate,
                controller: cardNumC,
                decoration: InputDecoration(
                    hintText: lang.translate('Card number'),
                    border: InputBorder.none,
                    fillColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  expiryCvvTextBox() {
    return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        child: Row(children: <Widget>[
          Expanded(
              flex: 11,
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black12)]),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: validate,
                  controller: expiryDateC,
                  decoration: InputDecoration(
                      hintText: lang.translate('Expire Date'),
                      border: InputBorder.none,
                      fillColor: Colors.blue),
                ),
              )),
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 4,
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black12)]),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: validate,
                  controller: cvvC,
                  decoration: InputDecoration(
                      hintText: 'CVV',
                      border: InputBorder.none,
                      fillColor: Colors.blue),
                ),
              )),
        ]));
  }

  payBookBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, bottom: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Expanded(
              flex: 8,
              child: Transform.translate(
                  offset: Offset(mediaQuery.size.width / 20, 0),
                  child: RaisedButton(
                    padding: EdgeInsets.all(13),
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.black54)),
                    onPressed: () {},
                    child: Text(
                      '$servicePrice \$',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.blueAccent),
                    ),
                  ))),
          Expanded(
            flex: 8,
            child: Transform.translate(
              offset: Offset(-mediaQuery.size.width / 20, 0),
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Color.fromRGBO(26, 119, 186, 1),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  String selectedPaymentID;
                  bool select = false;
                  for (int i = 0; i < selectionList.length; i++) {
                    if (selectionList[i].isSelected) {
                      selectedPaymentID = selectionList[i].doucumentID;
                      select = true;
                      //before booking we will check is user select location or not.
                      if (_user.geopoint != null)
                        bookTasker(selectedPaymentID);
                      else {
                        Utils.showToast('Update Location');
                      }
                      break;
                    }
                  }

                  //if no card selected then for tempory i will add empty payment field
                  if (!select) {
                    if (_user.geopoint != null)
                      bookTasker('');
                    else {
                      Utils.showToast('Update Location');
                    }
                  }

                  // if (!select) {
                  // Fluttertoast.showToast(
                  //     msg: "No card is selected",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.BOTTOM,
                  //     timeInSecForIos: 1,
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0);
                  // }
                },
                child: Text(
                  lang.translate('Pay & Book'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  String validate(String value) {
    if (value.isEmpty) {
      return "Can't be Empty";
    } else
      return null;
  }

  showPrompt() {
    return Visibility(
        visible: promptVisibility,
        child: Container(
          color: Color.fromRGBO(26, 119, 186, .4),
          child: prompt(),
        ));
  }

  prompt() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: gapFromBorder,
          height: MediaQuery.of(context).size.height / 1.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                    width: double.infinity,
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
                    child: Column(
                      children: <Widget>[
                        bookImageView(),
                        bookingConfirmationTxtBox(),
                        timmingBox(),
                      ],
                    )),
              ),
              okBtn(),
            ],
          ),
        ),
      ),
    );
  }

  okBtn() {
    return Container(
        width: double.infinity,
        child: RaisedButton(
          padding: EdgeInsets.all(13),
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            setState(() {
              promptVisibility = false;
            });
          },
          child: Text(
            'Ok',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.blueAccent),
          ),
        ));
  }

  bookImageView() {
    return Padding(
        padding: EdgeInsets.only(top: 30, bottom: 30),
        child: Image(
          image: AssetImage('assets/images/booking.png'),
        ));
  }

  bookingConfirmationTxtBox() {
    return Container(
      width: MediaQuery.of(context).size.width / 2.8,
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
            lang.translate('Your booking is confirmed'),
            textAlign: TextAlign.center,
            style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: Color.fromRGBO(26, 119, 186, 1),
                fontSize: 18),
          )),
        ],
      ),
    );
  }

  timmingBox() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.7,
        child: Column(
          children: <Widget>[
            Divider(
              height: 30,
              thickness: 2,
              color: Color.fromRGBO(26, 119, 186, 1),
            ),
            Center(
                child: Text(
              lang.translate('Your tasker will reach you in'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(26, 119, 186, 1),
                  fontSize: 17),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Center(
                  child: Text(
                '13',
                textAlign: TextAlign.center,
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(26, 119, 186, 1),
                    fontSize: 30),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                  child: Text(
                'min',
                textAlign: TextAlign.center,
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(26, 119, 186, 1),
                    fontSize: 18),
              )),
            ),
          ],
        ));
  }

  bookTasker(paymentuid) async {
    String result;
    try {
      await db
          .collection('book')
          .add({
            'taskername': taskername,
            'buyername': _user.name,
            'bookby': _user.uid,
            'bookto': _taskerID,
            'paymentuid': paymentuid,
            'price': servicePrice,
            'taskerimageurl': taskerImgUrl,
            'buyerimageurl': _user.imageUrl,
            'type': servicetype,
            'subtype': servicesubtype,
            'state': 'Waiting for tasker response',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'geopoint': _user.geopoint
          })
          .then((value) => {
                //add book array to users
                db.collection('users').document(_user.uid).updateData({
                  'booking': FieldValue.arrayUnion([value.documentID])
                }).catchError((error) {
                  print("doc save error");
                  print(error);
                }),
                //add request array to tasker
                print('taskerid: ' + _taskerID.toString()),
                db.collection('users').document(_taskerID).setData({
                  'requests': FieldValue.arrayUnion([value.documentID]),
                }, merge: true).catchError((error) {
                  print("doc save error");
                  print(error);
                }),
                //this method will add ref to user book array and tasker request array
                this.setState(() {
                  promptVisibility = true;
                }),
              })
          .timeout(Duration(seconds: 10))
          .catchError((error) {
            print("doc save error");
            print(error);
            result = error.toString();
            setState(() {
              Fluttertoast.showToast(
                  msg: result,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            });
          });
    } catch (e) {
      print('exception: ' + e.toString());
      result = e.toString();
      setState(() {
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }
}

class ListTileSelection {
  bool isSelected = false;
  String doucumentID;
  ListTileSelection(this.doucumentID);
}

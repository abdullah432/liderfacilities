import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/models/strings.dart';
import 'package:liderfacilites/screens/payment/payment.dart';
import 'package:liderfacilites/screens/payment/payment_card.dart';
import 'input_formaters.dart';

class AddPayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPaymentState();
  }
}

class AddPaymentState extends State<AddPayment> {
  MediaQueryData mediaQuery;
  AppLocalizations lang;
  Setting setting = new Setting();
  //styles
  TextStyle boldAlign = TextStyle(fontWeight: FontWeight.bold);
  //textboxes controllers
  TextEditingController _nameC = TextEditingController();
  TextEditingController _expiryDateC = TextEditingController();
  TextEditingController _cvvC = TextEditingController();

  User _user = new User();
  CustomFirestore _customFirestore = new CustomFirestore();

  /// Card Number Controller
  TextEditingController _cardNumberController = TextEditingController();
  // Declare Variables To Store Card Type and Validity
  String cardType;
  bool isValid = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _paymentCard = PaymentCard();
  //adding data waiting circular
  bool waiting = false;

  @override
  void dispose() {
    _nameC.dispose();
    _expiryDateC.dispose();
    _cvvC.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    lang = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: mediaQuery.size.height / 5,
              width: double.infinity,
              // color: setting.primaryColor,
              decoration: BoxDecoration(
                  color: setting.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
            )),
        Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              leading: IconButton(
                tooltip: 'back button',
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: new Text('My Payment'),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                Visibility(
                    visible: waiting,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 30, top: 7, bottom: 7),
                      child: Center(child: CircularProgressIndicator()),
                    )),
              ],
            ),
            body: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                      child: Column(
                    children: <Widget>[
                       Transform.translate(
                              offset: Offset(0, -20),
                              child: alreadyAddedCardView()),
                      
                      addNewCardView(),
                    ],
                  ))),
            ))),
      ],
    );
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
          return Visibility(visible: false,child: Container(width: 0.0, height: 0.0));

          // return Container(width: 0.0, height: 0.0);
        }
        if (snapshot.hasData) {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    print('length: ' + snapshot.length.toString());
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
    print('card number: ' + _cardnumber);

    return Padding(
        // key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 30, right: 30),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CardUtils.getCardIcon(cardType),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(_cardnumber.substring(0, 4)),
                        ),
                        Spacer(),
                        Text('EXP: '),
                        Text(_record.expirydate),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(''),
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              print('delete');
                              _customFirestore
                                  .deletePaymentMethod(data.documentID);
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            )),
                      ],
                    )
                  ],
                ))));
  }

  addNewCardView() {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: mediaQuery.size.width / 1.1,
          height: mediaQuery.size.height / 1.5,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  title2(),
                  nameTextBox(),
                  cardnumberTextBox(),
                  expiryCvvTextBox(),
                  addBtn()
                ],
              )),
        ));
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
              controller: _nameC,
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
                //for cardnumber validation i use plugin
                validator: validateCard,
                controller: _cardNumberController,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(19),
                  new CardNumberInputFormatter()
                ],
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
                  validator: CardUtils.validateDate,
                  controller: _expiryDateC,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(4),
                    new CardMonthInputFormatter()
                  ],
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
                  validator: CardUtils.validateCVV,
                  controller: _cvvC,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                      hintText: 'CVV',
                      border: InputBorder.none,
                      fillColor: Colors.blue),
                ),
              )),
        ]));
  }

  addBtn() {
    return Container(
        width: double.infinity,
        child: RaisedButton(
          padding: EdgeInsets.all(13),
          color: setting.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            print('Add payment to firestore');
            addPaymentDataToFirestore();
          },
          child: Text(
            'Add',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ));
  }

  String validate(String value) {
    if (value.isEmpty) {
      return "Can't be Empty";
    } else
      return null;
  }

  String validateCard(String value) {
    // Get Card Type and Validity Data As Map - @param Card Number
    Map<String, dynamic> cardData = CreditCardValidator.getCard(
        CardUtils.getCleanedNumber(_cardNumberController.text));
    setState(() {
      // Set Card Type and Validity
      cardType = cardData[CreditCardValidator.cardType];
      isValid = cardData[CreditCardValidator.isValidCard];
    });

    debugPrint('valid: ' + isValid.toString());
    if (isValid)
      return null;
    else
      return Strings.numberIsInvalid;
  }

  addPaymentDataToFirestore() {
    if (_formKey.currentState.validate()) {
      //start circular progress bar at top
      // waiting = true;

      _paymentCard.name = _nameC.text;
      _paymentCard.number =
          CardUtils.getCleanedNumber(_cardNumberController.text);
      _paymentCard.cvv = int.parse(_cvvC.text);

      // String result = _customFirestore.addNewPaymentMethod(_nameC.text,
      //     _paymentCard.number, _expiryDateC.text, _paymentCard.cvv);

      String result;
      try {
        Firestore.instance
            .collection('users')
            .document(_user.uid)
            .collection('card')
            .add({
              'nameoncard': _paymentCard.name,
              'cardnumber': _paymentCard.number,
              'expirydate': _expiryDateC.text,
              'cvv': _paymentCard.cvv
            })
            .then((value) => {
                  result = 'Payment Method added successfully',
                  _showInSnackBar(result),
                  waiting = false,
                })
            .timeout(Duration(seconds: 10))
            .catchError((error) {
              print("doc save error");
              print(error);
              result = error.toString();
              _showInSnackBar(result);
              setState(() {
                waiting = false;
              });
            });
      } catch (e) {
        print('exception: ' + e.toString());
        result = e.toString();
        _showInSnackBar(result);
      }
    }

    // _paymentCard.number =
    //     CardUtils.getCleanedNumber(_cardNumberController.text);
    // _paymentCard.name = _nameC.text;
    // print('date: ' + _expiryDateC.text);
    // print('name: ' + _paymentCard.name);
    // print('number: ' + _paymentCard.number);
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }
}

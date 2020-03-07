import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/models/strings.dart';
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
                  visible: false,
                  child: Padding(
                  padding: const EdgeInsets.only(right: 30, top: 7, bottom: 7),
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
                    children: <Widget>[addNewCardView()],
                  ))),
            ))),
      ],
    );
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
      waiting = true;

      _paymentCard.name = _nameC.text;
      _paymentCard.number =
          CardUtils.getCleanedNumber(_cardNumberController.text);
      _paymentCard.cvv = int.parse(_cvvC.text);

      CustomFirestore _customFirestore = new CustomFirestore();
      // String result = _customFirestore.addNewPaymentMethod(_nameC.text,
      //     _paymentCard.number, _expiryDateC.text, _paymentCard.cvv);

      String result;
      User _user = new User();
      try {
        Firestore.instance
            .collection('users')
            .document(_user.uid)
            .collection('payment')
            .add({
              'nameoncard': _paymentCard.name,
              'cardnumber': _paymentCard.number,
              'expirydate': _expiryDateC.text,
              'cvv': _paymentCard.cvv
            })
            .then((value) => {
                  result = 'Payment Method added successfully',
                  _showInSnackBar(result),
                  waiting = false
                })
            .timeout(Duration(seconds: 10))
            .catchError((error) {
              print("doc save error");
              print(error);
              result = error.toString();
              _showInSnackBar(result);

              waiting = false;
            });
      } catch (e) {
        print('exception: ' + e.toString());
        result = e.toString();
        _showInSnackBar(result);

        waiting = false;
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

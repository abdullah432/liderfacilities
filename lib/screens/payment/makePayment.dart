import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';

class Payment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<Payment> {
  MediaQueryData mediaQuery;
  AppLocalizations lang;

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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
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
      padding: EdgeInsets.only(top: 30.0),
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
                      '300 \$',
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
                  // navigateToPaymentPage();
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
    return Visibility(visible: promptVisibility, child: Container(
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
            print('hide prompt');
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
}

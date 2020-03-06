import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/setting.dart';

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
  TextEditingController nameC = TextEditingController();
  TextEditingController cardNumC = TextEditingController();
  TextEditingController expiryDateC = TextEditingController();
  TextEditingController cvvC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            ),
            body: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    child: addNewCardView(),
                  )),
            ))),
      ],
    );
  }

  addNewCardView() {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: mediaQuery.size.width / 1.1,
          height: mediaQuery.size.height / 1.7,
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

}

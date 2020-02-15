import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';

class EditInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditInfoState();
  }
}

class EditInfoState extends State<EditInfo> {
  String _imageUrl;
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('EditInfo')),
          actions: <Widget>[
            Center(
                child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        updateRecord();
                      },
                      child: Text(AppLocalizations.of(context).translate('Update'),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    )))
          ],
        ),
        body: Container(
          child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    imageView(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        AppLocalizations.of(context).translate('Change Profile'),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    nameTF(),
                    emailTF(),
                    phoneTF(),
                  ],
                ),
              )),
        ));
  }

  imageView() {
    return Center(
        child: CircleAvatar(
      radius: 70,
      child: _imageUrl == null
          ? Image.asset(
              'assets/images/account.png',
            )
          : Image.network(_imageUrl, fit: BoxFit.cover),
    ));
  }

  nameTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
          width: MediaQuery.of(context).size.width / 1.25,
          padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
          child: TextFormField(
            // textAlign: TextAlign.center
            keyboardType: TextInputType.text,
            validator: validateName,
            controller: nameC,
            // onSaved: (value) {
            //   _name = value;
            // },
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('Name'),
                border: InputBorder.none,
                fillColor: Colors.blue),
          )),
    );
  }

  emailTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.25,
              padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
              child: TextFormField(
                // textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                controller: emailC,
                // onSaved: (value) {
                //   _email = value;
                // },
                decoration: InputDecoration(
                    // hintText: 'Email',
                    hintText: AppLocalizations.of(context).translate('Email'),
                    border: InputBorder.none,
                    fillColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  phoneTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.25,
        padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
        child: TextFormField(
          // textAlign: TextAlign.center,
          keyboardType: TextInputType.phone,
          validator: validateMobile,
          controller: phoneC,
          // onSaved: (value) {
          //   _phonenumber = int.parse(value);
          // },
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate('PhoneNumber'),
              border: InputBorder.none,
              fillColor: Colors.blue),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validateName(String value) {
    if (value.length < 3)
      return AppLocalizations.of(context)
          .translate('Name must be more than 2 charater');
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length < 10)
      return AppLocalizations.of(context)
          .translate('Mobile Number must be of 10 digit');
    else
      return null;
  }

  //update record in firestore
  updateRecord(){
    print('Update record');
  }
}

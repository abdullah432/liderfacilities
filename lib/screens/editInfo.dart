import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class EditInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditInfoState();
  }
}

class EditInfoState extends State<EditInfo> {
  File _image;
  String _imageUrl;
  User user = new User();
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  //upload imageurl progress bar
  bool progress = false;

  @override
  void initState() {
    nameC.text = user.name;
    emailC.text = user.email;
    phoneC.text = user.phoneNumber.toString();
    _imageUrl = user.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('EditInfo')),
          actions: <Widget>[
            Center( child:
                GestureDetector(
                      onTap: () {
                        updateRecord(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            AppLocalizations.of(context).translate('Update'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ))
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
                        AppLocalizations.of(context)
                            .translate('Change Profile'),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    nameTF(),
                    emailTF(),
                    phoneTF(),
                    uploadProgressBar(),
                  ],
                ),
              )),
        ));
  }

  imageView() {
    return Center(
        child: GestureDetector(
            onTap: () {
              getImage();
            },
            child: CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: _image == null
                          ? _imageUrl == null? Image.asset(
                              'assets/images/account.png',
                            )
                          : Image.network(_imageUrl, fit: BoxFit.cover, width: 170,)
                      : Image.file(_image, fit: BoxFit.cover, width: 170,),
                ))));
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

  uploadProgressBar() {
    return Visibility(
        visible: progress,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: CircularProgressIndicator(),
        ));
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
  updateRecord(BuildContext context) async {
    var db = Firestore.instance;
    if (_formKey.currentState.validate()) {
      //start showing upload progress bar
      setState(() {
        progress = true;
      });
      //first uploadImageToStorage
      String filename = p.basename(_image.path);
      StorageReference fstorageRef =
          FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = fstorageRef.putFile(_image);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      //update other info
      if (user.email != emailC.text ||
          user.phoneNumber != phoneC ||
          user.name != nameC.text) {
        try {
          db.collection('users').document(user.uid).updateData({
            'name': nameC.text,
            'email': emailC.text,
            'phonenumber': int.parse(phoneC.text)
          });
        } catch (e) {
          print(e.toString());
        }
      }

      if (_image != null) {
        try {
          db
              .collection('users')
              .document(user.uid)
              .updateData({'imageurl': downloadUrl});
        } catch (e) {
          print(e.toString());
        }
      }
      progress = false;
      _image = null;
      Navigator.pop(context);
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    setState(() {
      _image = image;
    });
  }
}

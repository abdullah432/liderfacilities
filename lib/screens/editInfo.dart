import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liderfacilites/models/firestore.dart';
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
  TextEditingController regC = TextEditingController();
  TextEditingController cnpj_cpfC = TextEditingController();
  //upload imageurl progress bar
  bool progress = false;
  //checkboxes
  bool cnpj = false;
  bool cpf = false;
  //cnpj or cpf textbox will be invisible until ono box selected
  bool cnpj_cpf_visibility = false;
  //
  AppLocalizations lang;
  //user location
  Geolocator geolocator = Geolocator();
  Position userLocation;
  String _userAddress = 'Not selected';

  @override
  void initState() {
    nameC.text = user.name;
    emailC.text = user.email;
    phoneC.text = user.phoneNumber.toString();
    _imageUrl = user.imageUrl;
    if (user.address != null) {
      _userAddress = user.address;
    }
    if (user.reg != null) {
      regC.text = user.reg;
    }
    if (user.socialsecurity != null) {
      print('social: ' + user.socialsecurity);
      if (user.socialsecurity == 'Cnpj')
        cnpj = true;
      else if (user.socialsecurity == 'Cpf') cpf = true;
    }
    if (user.socialsecuritynumber != null) {
      cnpj_cpf_visibility = true;
      cnpj_cpfC.text = user.socialsecuritynumber;
    }

    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    regC.dispose();
    cnpj_cpfC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(AppLocalizations.of(context).translate('EditInfo')),
        //   actions: <Widget>[
        //     Center(
        //         child: GestureDetector(
        //       onTap: () {
        //         updateRecord(context);
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(10.0),
        //         child: Text(AppLocalizations.of(context).translate('Update'),
        //             style:
        //                 TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        //       ),
        //     ))
        //   ],
        // ),
        body: SingleChildScrollView(
      child: Container(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            uperPart(),
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 22, right: 22),
              child: Divider(
                thickness: 1,
              ),
            ),
            regTF(),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 22, right: 22),
              child: Divider(
                thickness: 1,
              ),
            ),
            checkboxes(),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 22, right: 22),
              child: Divider(
                thickness: 1,
              ),
            ),
            locationbox(),
            uploadProgressBar(),
          ],
        ),
      )),
    ));
  }

  uperPart() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6.3,
        decoration: BoxDecoration(
            color: Color.fromRGBO(26, 119, 186, 1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('EditInfo'),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        updateRecord(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(AppLocalizations.of(context).translate('Update'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ),
                  ],
                ))),
      ),
    );
  }

  imageView() {
    return Center(
        child: GestureDetector(
            onTap: () {
              //remove cursor blink of search textfield
              FocusScope.of(context).requestFocus(new FocusNode());
              getImage();
            },
            child: CircleAvatar(
                radius: 80,
                // backgroundColor: Colors.black,
                child: ClipOval(
                  child: _image == null
                      ? _imageUrl == null
                          ? Image.asset(
                              'assets/images/account.png',
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : FadeInImage.assetNetwork(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              fadeInCurve: Curves.bounceIn,
                              placeholder: 'assets/images/account.png',
                              image: _imageUrl,
                            )
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ))));
    // CircleAvatar(
    //     radius: 70,
    //     child: ClipOval(
    //       child: _image == null
    //           ? _imageUrl == null
    //               ? Image.asset(
    //                   'assets/images/account.png',
    //                 )
    //               : Image.network(
    //                   _imageUrl,
    //                   fit: BoxFit.cover,
    //                   width: 170,
    //                 )
    //           : Image.file(
    //               _image,
    //               fit: BoxFit.cover,
    //               width: 170,
    //             ),
    //     )),
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
      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
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

  regTF() {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.25,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Reg',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
                child: TextFormField(
                  // textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  controller: regC,
                  // onSaved: (value) {
                  //   _phonenumber = int.parse(value);
                  // },
                  decoration: InputDecoration(
                      hintText: lang.translate('Enter Reg'),
                      border: InputBorder.none,
                      fillColor: Colors.blue),
                ),
              ),
            ],
          ),
        ));
  }

  checkboxes() {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5),
        child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Cnpj",
                        style: TextStyle(fontSize: 18),
                      ),
                      Checkbox(
                        value: cnpj,
                        onChanged: (bool value) {
                          setState(() {
                            //when select make text box visible
                            cnpj_cpf_visibility = true;

                            cnpj = value;
                            cpf = !value;
                          });
                        },
                      ),
                      VerticalDivider(color: Colors.black, width: 30),
                      Text(
                        "Cpf",
                        style: TextStyle(fontSize: 18),
                      ),
                      Checkbox(
                        value: cpf,
                        onChanged: (bool value) {
                          setState(() {
                            //when select make text box visible
                            cnpj_cpf_visibility = true;

                            cpf = value;
                            cnpj = !value;
                          });
                        },
                      ),
                    ],
                  ),
                  Visibility(
                      visible: cnpj_cpf_visibility,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 3, bottom: 3, right: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 1)
                            ]),
                        child: TextFormField(
                          // textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          controller: cnpj_cpfC,
                          // onSaved: (value) {
                          //   _phonenumber = int.parse(value);
                          // },
                          decoration: InputDecoration(
                              hintText: lang.translate('Enter here'),
                              border: InputBorder.none,
                              fillColor: Colors.blue),
                        ),
                      )),
                ],
              ),
            )));
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
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        lang.translate('Location'),
                        style: TextStyle(fontSize: 18),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(children: <Widget>[
                    Icon(
                      Icons.add_location,
                      color: Colors.black38,
                      size: 15,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        _userAddress,
                        style: TextStyle(fontSize: 9, color: Colors.black38),
                      ),
                    ))
                  ]),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset('assets/images/location.png',
                      width: MediaQuery.of(context).size.width / 1.25,
                      height: MediaQuery.of(context).size.width / 3.5,
                      fit: BoxFit.cover),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: FlatButton(
                      onPressed: () {
                        _getLocation().then((value) {
                          setState(() {
                            userLocation = value;
                          });
                        });
                      },
                      child: Text(
                        lang.translate('Use current Location'),
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                      ),
                    ))
              ],
            )));
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
    var db = Firestore.instance.collection('users');
    if (_formKey.currentState.validate()) {
      //start showing upload progress bar
      setState(() {
        progress = true;
      });
      debugPrint('imageurl: ' + _image.toString());
      //if image is null then we does not need below code
      if (_image != null) {
        //first uploadImageToStorage
        String filename = p.basename(_image.path);
        StorageReference fstorageRef =
            FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask = fstorageRef.putFile(_image);
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        debugPrint('downloadUrl: ' + downloadUrl);
        try {
          db.document(user.uid).updateData({'imageurl': downloadUrl});
          //need to change imageurl in multiple location
          if (user.isTasker)
            db.document(user.uid).updateData({'imgurl': downloadUrl});
        } catch (e) {
          print(e.toString());
        }
      }

      //update other info
      if (user.email != emailC.text ||
          user.phoneNumber != phoneC ||
          user.name != nameC.text) {
        try {
          db.document(user.uid).updateData({
            'name': nameC.text,
            'email': emailC.text,
            'phonenumber': int.parse(phoneC.text)
          });
        } catch (e) {
          print(e.toString());
        }
      }

      //social_security part
      String social_security;
      if (cnpj) {
        social_security = 'Cnpj';
      } else if (cpf) {
        social_security = 'Cpf';
      }

      if (social_security != null) {
        try {
          db.document(user.uid).updateData({
            'social_security': social_security,
            'social_security_number': cnpj_cpfC.text,
          });
        } catch (e) {
          print(e.toString());
        }
      }
      //reg part
      if (regC.text.isNotEmpty) {
        try {
          db.document(user.uid).updateData({
            'reg': regC.text,
          });
        } catch (e) {
          print(e.toString());
        }
      }
      //location part
      if (_userAddress != 'Not selected' && _userAddress != null && userLocation != null) {
        try {
          db.document(user.uid).updateData({
            'address': _userAddress,
            'geopoint': GeoPoint(userLocation.latitude, userLocation.longitude)
          });
        } catch (e) {
          print('user location:' + e.toString());
        }

        //if user is tasker too. Then update location and geopoint values on all services
        if (user.isTasker) {
          var db = Firestore.instance;
          // DocumentReference docRef = db.collection('users').document(user.uid);
          // QuerySnapshot querySnapshot = await Firestore.instance
          //     .collection("services")
          //     .where('reference', isEqualTo: docRef)
          //     .getDocuments();
          CustomFirestore _customfirestore = new CustomFirestore();
          var list = await _customfirestore.getAllTasker();
          list.forEach((e) => {
                db.collection("services").document(e.documentID).updateData({
                  'address': _userAddress,
                  'geopoint':
                      GeoPoint(userLocation.latitude, userLocation.longitude)
                })
              });
        }
      }

      progress = false;
      _image = null;
      Navigator.pop(context, true);
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    if (this.mounted) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<Position> _getLocation() async {
    try {
      userLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }

    final coordinates =
        new Coordinates(userLocation.latitude, userLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      _userAddress = first.addressLine;
    });

    return userLocation;
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liderfacilites/models/Service.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/services.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:path/path.dart' as p;

class EditService extends StatefulWidget {
  var serviceData;
  var serviceUid;
  EditService(this.serviceUid, this.serviceData);
  @override
  State<StatefulWidget> createState() {
    return EditServiceState(serviceUid, serviceData);
  }
}

class EditServiceState extends State<EditService> with WidgetsBindingObserver {
  Service serviceData;
  var serviceUid;
  EditServiceState(this.serviceUid, this.serviceData);
  AppLocalizations lang;
  //for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController hrC = new TextEditingController();
  TextEditingController desC = new TextEditingController();

  var typeofservices = ['CLEANING'];

  String _dropdowntosError;
  //for dropdown
  String selectedService;
  //for subtype selectin
  String selService;
  String _dropdownscError;
  var subTypesList = ['SELECT SERVICE FIRST'];
  String selectedSubCategory;

  //Service image file
  File _serviceImageFile;
  //error if user not select image, default it's value will be ''
  String errorOrDefault = '';
  bool showRedText = false;

  Setting _setting = new Setting();
  //show circularprogressbar when user click on save btn
  bool dataUploading = false;

  //snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var language;

  @override
  void initState() {
    //language of prviously selected type
    language = checkTypeLang(serviceData.typeofservice);
    initServices();
    if (serviceData != null) {
      print('type: ' + serviceData.typeofservice);
      print('subtype: ' + serviceData.subtype);
      print('lang: ' + language);
      if (language != 'English') {
        selectedService = serviceData.typeofservice;
        selService = selectServiceConvertToEnglish(selectedService);
      } else {
        selectedService = serviceData.typeofservice;
        selService = serviceData.typeofservice;
      }

      selectSubtype();

      //selected subtype
      selectedSubCategory = serviceData.subtype;

      //after that allocate price description
      hrC.text = serviceData.hourlyrate;
      desC.text = serviceData.description;
    }
    super.initState();
  }

  initServices() {
    if (language == 'English') {
      typeofservices = Services.typeofservicesInENG;
      debugPrint('englishinit');
    } else {
      typeofservices = Services.typeofservicesInBR;
      debugPrint('brinit');
    }
  }

  @override
  void dispose() {
    hrC.dispose();
    desC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        addServiceUI(),
        uploadingCircularBar(),
      ],
    );
  }

  addServiceUI() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(lang.translate('Add Services')),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    // height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                lang.translate('Type of service'),
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 20, right: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: typeofservicedropdown(),
                            )),
                        _dropdowntosError == null
                            ? SizedBox.shrink()
                            : Text(
                                _dropdowntosError ?? "",
                                style: TextStyle(color: Colors.red),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                lang.translate('Sub category'),
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 20, right: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: subcategorydropdown(),
                            )),
                        _dropdownscError == null
                            ? SizedBox.shrink()
                            : Text(
                                _dropdownscError ?? "",
                                style: TextStyle(color: Colors.red),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                lang.translate('Fixed Rate'),
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 20, right: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: hourlyRateTextBox(),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                lang.translate('Description'),
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 20, right: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: descriptionTextBox(),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    lang.translate(
                                        'Upload Image related to your service'),
                                    // 'Upload Image related to your service',
                                    style: TextStyle(fontSize: 13),
                                  )),
                                  GestureDetector(
                                      onTap: () {
                                        //load image
                                        getImage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 35, top: 10, bottom: 10),
                                        child: Icon(
                                          Icons.cloud_upload,
                                          color: Colors.blue,
                                        ),
                                      )),
                                ]),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      _serviceImageFile != null
                                          ? p.basename(_serviceImageFile.path)
                                          : errorOrDefault,
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: showRedText
                                              ? Colors.red
                                              : Colors.black),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: saveButton()),
                      ]),
                    )),
              ))),
    );
  }

  uploadingCircularBar() {
    return Visibility(
        // visible: true,
        visible: dataUploading,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black26,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 35);
    if (this.mounted) {
      setState(() {
        _serviceImageFile = image;
        //image not pick error color
        showRedText = false;
      });
    }
  }

  typeofservicedropdown() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.black12,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            items: typeofservices.map((String dropDownStringItem) {
              return DropdownMenuItem(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            hint: Text(lang.translate('Select type')),
            decoration: InputDecoration(
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none)),
            validator: (value) =>
                value == null ? lang.translate('This field is required') : null,
            onChanged: (String value) {
              setState(() {
                print(value);

                // selService = null;
                // subTypesList.clear();
                // _formKey.currentState.reset();
                subTypesList = ['SELECT SERVICE FIRST'];
                selectedSubCategory = null;

                if (language != 'English') {
                  selectedService = value;
                  selService = selectServiceConvertToEnglish(value);
                } else {
                  selectedService = value;
                  selService = value;
                }

                selectSubtype();
              });
            },
            value: selectedService,
          )),
    );
  }

  String selectServiceConvertToEnglish(value) {
    switch (value) {
      case 'DE LIMPEZA':
        return 'CLEANING';
        break;
      case 'DE AR-CONDICIONADO':
        return 'AIR CONDITIONING';
        break;
      case 'MOTORISTA':
        return 'DRIVER';
        break;
      case 'Eletricistas':
        return 'ELECTRICAL';
        break;
      case 'MUSICA':
        return 'MUSIC';
        break;
      case 'HIDRÁULICOS':
        return 'HYDRAULIC';
        break;
      case 'MONTAGEM DE MÓVEIS':
        return 'FURNITURE ASSEMBLY';
        break;
      case 'ASSISTÊNCIA TÉCNICA':
        return 'TECHNICAL ASSISTANCE';
        break;
      case 'MASSAGENS E TERAPIAS':
        return 'MASSAGES AND THERAPIES';
        break;
      case 'CHAVEIRO':
        return 'LOCKSMITH';
        break;
      case 'CUIDADOR IDOSO':
        return 'ELDERLY CAREGIVER';
        break;
      case 'FOTOGRAFO':
        return 'PHOTOGRAPHER';
        break;
      case 'JARDINEIRO':
        return 'GARDENER';
        break;
      case 'LAVAGEM DE CARRO':
        return 'CAR WASH';
        break;
      case 'ALIMENTAÇÃO':
        return 'FOOD';
        break;
      case 'AUTOMOVEIS':
        return 'AUTOMOBILES';
        break;
      case 'MANUTENÇÃO':
        return 'MAINTENANCE';
        break;
      case 'ANIMACÃO DE FESTAS':
        return 'PARTY ANIMATION';
        break;
      case 'VIDRACEIRO':
        return 'GLASS';
        break;
      case 'DE REFORMA':
        return 'REFORM';
        break;
      case 'FRETES':
        return 'FREIGHT';
        break;
      default:
        return '';
    }
  }

  subcategorydropdown() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.black12,
        // color: Color.fromARGB(224, 224, 224, 100),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            isExpanded: true,
            // decoration: InputDecoration(
            //     enabledBorder:
            //         UnderlineInputBorder(borderSide: BorderSide.none)),
            items: subTypesList.map((String dropDownStringItem) {
              return DropdownMenuItem(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            hint: Text(lang.translate('Select sub category')),
            // validator: (value) => value == null ? 'Field required' : null,
            onChanged: (String value) {
              setState(() {
                selectedSubCategory = value;
              });
            },
            value: selectedSubCategory != null ? selectedSubCategory : null,
          ))),
    );
  }

  hourlyRateTextBox() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // width: MediaQuery.of(context).size.width / 1.25,
            padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                // color: Colors.black12,
                boxShadow: [BoxShadow(color: Colors.black12)]),
            child: TextFormField(
              // cursorColor: Color.fromARGB(214, 214, 214, 100),
              // textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              validator: validateHR,
              controller: hrC,
              // onSaved: (value) {
              //   _email = value;
              // },
              decoration: InputDecoration(
                  // hintText: 'Email',
                  hintText: "R\$ 50.00",
                  border: InputBorder.none,
                  fillColor: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  String validateHR(String value) {
    if (value.isEmpty) {
      return lang
          .translate('Your description need to be atleast 12 characters');
    } else
      return null;
  }

  descriptionTextBox() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // width: MediaQuery.of(context).size.width / 1.25,
            padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                // color: Colors.black12,
                boxShadow: [BoxShadow(color: Colors.black12)]),
            child: TextFormField(
              // cursorColor: Color.fromARGB(214, 214, 214, 100),
              // textAlign: TextAlign.center,
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              validator: validateDescription,
              controller: desC,
              // onSaved: (value) {
              //   _email = value;
              // },
              decoration: InputDecoration(
                  // hintText: 'Email',
                  hintText: lang.translate('EnterDescription'),
                  border: InputBorder.none,
                  fillColor: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  String validateDescription(String valule) {
    if (valule.length < 12) {
      return lang
          .translate('Your description need to be atleast 12 characters');
    } else
      return null;
  }

  saveButton() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width / 1.65,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
      child: RaisedButton(
        color: Color.fromRGBO(26, 119, 186, 1),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        onPressed: () {
          saveService();
        },
        child: Text(
          lang.translate('Save'),
          // AppLocalizations.of(context).translate('Login'),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
      ),
    );
  }

  saveService() async {
    if (_formKey.currentState.validate()) {
      //make circularprogressindicator visible
      setState(() {
        dataUploading = true;
      });

      if (serviceData == null) {
        //after that check if image for this service is selected or not, if not then show error
        if (_serviceImageFile != null) {
          //if user select image then first upload image and get url
          String filename = p.basename(_serviceImageFile.path);
          StorageReference fstorageRef =
              FirebaseStorage.instance.ref().child(filename);
          StorageUploadTask uploadTask = fstorageRef.putFile(_serviceImageFile);
          StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
          String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

          User user = new User();
          //before adding new service pick user location
          GeoPoint _geoPoint;
          if (user.geopoint != null) {
            _geoPoint = user.geopoint;
          } else {
            _geoPoint = _setting.location;
          }
          CustomFirestore firestore = new CustomFirestore();
          bool result;
          result = await firestore.createServiceRecord(selectedService,
              selectedSubCategory, hrC.text, desC.text, downloadUrl, _geoPoint);

          user.setUserState(true);
          Navigator.pop(context, true);
          if (result) {
            //when user add service, this mean he is now tasker too.
            firestore.updateToTasker();
            showSnachBar(lang.translate('Successfully Added'), 1);
          } else {
            showSnachBar(lang.translate('Fail to add'), 2);
          }
        } else {
          if (this.mounted) {
            setState(() {
              errorOrDefault = 'Image is not selected';
              showRedText = true;
            });
          }
          //make circularprogressindicator invisible
          setState(() {
            dataUploading = false;
          });
        }
      } else {
        var downloadUrl;
        if (_serviceImageFile != null) {
          String filename = p.basename(_serviceImageFile.path);
          StorageReference fstorageRef =
              FirebaseStorage.instance.ref().child(filename);
          StorageUploadTask uploadTask = fstorageRef.putFile(_serviceImageFile);
          StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
          downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        } else {
          downloadUrl = serviceData.imageurl;
        }

        User user = new User();
        //before adding new service pick user location
        GeoPoint _geoPoint;
        if (user.geopoint != null) {
          _geoPoint = user.geopoint;
        } else {
          _geoPoint = _setting.location;
        }
        CustomFirestore firestore = new CustomFirestore();
        bool result;
        result = await firestore.updateServiceRecord(
            serviceUid,
            selectedService,
            selectedSubCategory,
            hrC.text,
            desC.text,
            downloadUrl,
            _geoPoint);

        user.setUserState(true);
        dataUploading = false;
        Navigator.pop(context, true);
        if (result) {
          //when user add service, this mean he is now tasker too.
          firestore.updateToTasker();
          showSnachBar(lang.translate('Successfully Added'), 1);
        } else {
          showSnachBar(lang.translate('Fail to add'), 2);
        }
      }
    }
  }

  showSnachBar(String msg, int choice) {
    if (choice == 1) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Colors.green),
        ),
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Colors.red),
        ),
      ));
    }
  }

  selectSubtype() {
    print('selectService: ' + selService.toString());

    switch (selService) {
      case 'CLEANING':
        if (language == 'English')
          subTypesList = Services.subtypeofcleaningInENG;
        else
          subTypesList = Services.subtypeofcleaningInBR;
        break;
      case 'AIR CONDITIONING':
        if (language == 'English')
          subTypesList = Services.subtypeofAirCONDITIONINGInENG;
        else
          subTypesList = Services.subtypeofAirCONDITIONINGInBR;
        break;
      case 'DRIVER':
        if (language == 'English')
          subTypesList = Services.subtypeofDriverInENG;
        else
          subTypesList = Services.subtypeofDriverInBR;
        break;
      case 'ELECTRICAL':
        if (language == 'English')
          subTypesList = Services.subtypeofElectricalInENG;
        else
          subTypesList = Services.subtypeofElectricalInBR;
        break;
      case 'MUSIC':
        if (language == 'English')
          subTypesList = Services.subtypeofMusicInENG;
        else
          subTypesList = Services.subtypeofMusicInBR;
        break;
      case 'HYDRAULIC':
        if (language == 'English')
          subTypesList = Services.subtypeofHYDRAULICInENG;
        else
          subTypesList = Services.subtypeofHYDRAULICInBR;
        break;
      case 'REFORM':
        if (language == 'English')
          subTypesList = Services.subtypeofREFORMInENG;
        else
          subTypesList = Services.subtypeofREFORMInBR;
        break;
      case 'FURNITURE ASSEMBLY':
        if (language == 'English')
          subTypesList = Services.subtypeofFURNITUREASSEMBLYInENG;
        else
          subTypesList = Services.subtypeofFURNITUREASSEMBLYInBR;
        break;
      case 'FREIGHT':
        if (language == 'English')
          subTypesList = Services.subtypeofFREIGHTInENG;
        else
          subTypesList = Services.subtypeofFREIGHTInBR;
        break;
      case 'TECHNICAL ASSISTANCE':
        if (language == 'English')
          subTypesList = Services.subtypeofTECHNICALASSISTANCEInENG;
        else
          subTypesList = Services.subtypeofTECHNICALASSISTANCEInBR;
        break;
      case 'GLASS':
        if (language == 'English')
          subTypesList = Services.subtypeofGLASSInENG;
        else
          subTypesList = Services.subtypeofGLASSInBR;
        break;
      case 'MASSAGES AND THERAPIES':
        if (language == 'English')
          subTypesList = Services.subtypeofMAINTENANCEInENG;
        else
          subTypesList = Services.subtypeofMAINTENANCEInBR;
        break;
      case 'PARTY ANIMATION':
        if (language == 'English')
          subTypesList = Services.subtypeofPARTYANIMATIONInENG;
        else
          subTypesList = Services.subtypeofPARTYANIMATIONInBR;
        break;
      case 'BIKEBOY':
        if (language == 'English')
          subTypesList = Services.subtypeofBIKEBOYInENG;
        else
          subTypesList = Services.subtypeofBIKEBOYInBR;
        break;
      case 'LOCKSMITH':
        if (language == 'English')
          subTypesList = Services.subtypeofLOCKSMITHInENG;
        else
          subTypesList = Services.subtypeofLOCKSMITHInBR;
        break;
      case 'ELDERLY CAREGIVER':
        if (language == 'English')
          subTypesList = Services.subtypeofELDERLYCAREGIVERInENG;
        else
          subTypesList = Services.subtypeofELDERLYCAREGIVERInBR;
        break;
      case 'PHOTOGRAPHER':
        if (language == 'English')
          subTypesList = Services.subtypeofPHOTOGRAPHERInENG;
        else
          subTypesList = Services.subtypeofPHOTOGRAPHERInBR;
        break;
      case 'GARDENER':
        if (language == 'English')
          subTypesList = Services.subtypeofGARDENERInENG;
        else
          subTypesList = Services.subtypeofGARDENERInBR;
        break;
      case 'CAR WASH':
        if (language == 'English')
          subTypesList = Services.subtypeofCARWASHInENG;
        else
          subTypesList = Services.subtypeofCARWASHInBR;
        break;
      case 'PETS':
        if (language == 'English')
          subTypesList = Services.subtypeofPETSInENG;
        else
          subTypesList = Services.subtypeofPETSInBR;
        break;
      case 'MANICURE':
        if (language == 'English')
          subTypesList = Services.subtypeofMANICUREInENG;
        else
          subTypesList = Services.subtypeofMANICUREInBR;
        break;
      case 'FOOD':
        if (language == 'English')
          subTypesList = Services.subtypeofFOODInENG;
        else
          subTypesList = Services.subtypeofFOODInBR;
        break;
      case 'AUTOMOBILES':
        if (language == 'English')
          subTypesList = Services.subtypeofAUTOMOBILESInENG;
        else
          subTypesList = Services.subtypeofAUTOMOBILESInBR;
        break;
      case 'MAINTENANCE':
        if (language == 'English')
          subTypesList = Services.subtypeofMAINTENANCEInENG;
        else
          subTypesList = Services.subtypeofMAINTENANCEInBR;
        break;
      case 'PERSONAL TRAINER':
        if (language == 'English')
          subTypesList = Services.subtypeofPERSONALTRAINERInENG;
        else
          subTypesList = Services.subtypeofPERSONALTRAINERInBR;
        break;
    }
  }

  String checkTypeLang(value) {
    switch (value) {
      case 'DE LIMPEZA':
      case 'DE AR-CONDICIONADO':
      case 'MOTORISTA':
      case 'Eletricistas':
      case 'MUSICA':
      case 'HIDRÁULICOS':
      case 'MONTAGEM DE MÓVEIS':
      case 'ASSISTÊNCIA TÉCNICA':
      case 'MASSAGENS E TERAPIAS':
      case 'CHAVEIRO':
      case 'CUIDADOR IDOSO':
      case 'FOTOGRAFO':
      case 'JARDINEIRO':
      case 'LAVAGEM DE CARRO':
      case 'ALIMENTAÇÃO':
      case 'AUTOMOVEIS':
      case 'MANUTENÇÃO':
      case 'ANIMACÃO DE FESTAS':
      case 'VIDRACEIRO':
      case 'DE REFORMA':
      case 'FRETES':
        return 'Portuguese';
      default:
        return 'English';
    }
  }
}

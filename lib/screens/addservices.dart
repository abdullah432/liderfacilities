import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/firestore.dart';
import 'package:liderfacilites/models/services.dart';
import 'package:liderfacilites/models/setting.dart';

class AddService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddServiceState();
  }
}

class AddServiceState extends State<AddService> with WidgetsBindingObserver {
  AppLocalizations lang;
  //for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController hrC = new TextEditingController();
  TextEditingController desC = new TextEditingController();

  var typeofservices = ['CLEANING'];
  var subTypesList = ['SELECT SERVICE FIRST'];

  String _dropdowntosError;
  String selectedService;
  String _dropdownscError;
  String selectedSubCategory;

  Setting _setting = new Setting();
  Services services = new Services();

  //snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initServices();
    super.initState();
  }

  initServices() {
    if (_setting.getLanguage() == 'English') {
      typeofservices = services.typeofservicesInENG;
      debugPrint('englishinit');
    } else {
      typeofservices = services.typeofservicesInBR;
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
                                  lang.translate('Hourly Rate'),
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
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: saveButton()),
                        ]),
                      )),
                ))));
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
            hint: Text('Select type'),
            decoration: InputDecoration(
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none)),
            validator: (value) => value == null ? 'Field required' : null,
            onChanged: (String value) {
              setState(() {
                selectedService = value;
                selectSubtype();
              });
            },
            value: selectedService,
          )),
    );
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
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none)),
            items: subTypesList.map((String dropDownStringItem) {
              return DropdownMenuItem(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            hint: Text('Select sub category'),
            validator: (value) => value == null ? 'Field required' : null,
            onChanged: (String value) {
              setState(() {
                selectedSubCategory = value;
              });
            },
            value: selectedSubCategory,
          )),
    );
  }

  hourlyRateTextBox() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // width: MediaQuery.of(context).size.width / 1.25,
            padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
                // color: Colors.black12,
                boxShadow: [BoxShadow(color: Colors.black12)]),
            child: TextFormField(
              cursorColor: Color.fromARGB(214, 214, 214, 100),
              // textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              validator: validateHR,
              controller: hrC,
              // onSaved: (value) {
              //   _email = value;
              // },
              decoration: InputDecoration(
                  // hintText: 'Email',
                  hintText: "\$ 50.00",
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
                // color: Colors.black12,
                boxShadow: [BoxShadow(color: Colors.black12)]),
            child: TextFormField(
              cursorColor: Color.fromARGB(214, 214, 214, 100),
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
          'Save',
          // AppLocalizations.of(context).translate('Login'),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
      ),
    );
  }

  saveService() async {
    if (_formKey.currentState.validate()) {
      CustomFirestore firestore = new CustomFirestore();
      bool result = await firestore.createServiceRecord(
          selectedService, selectedSubCategory, hrC.text, desC.text);
      if (result) {
        //when user add service, this mean he is now tasker too.
        firestore.updateToTasker();
        showSnachBar(lang.translate('Successfully Added'), 1);
      } else {
        showSnachBar(lang.translate('Fail to add'), 2);
      }

      Navigator.of(context).pop();
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
    switch (selectedService) {
      case 'CLEANING':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofcleaningInENG;
        else
          subTypesList = services.subtypeofcleaningInBR;
        break;
      case 'AIR CONDITIONING':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofAirCONDITIONINGInENG;
        else
          subTypesList = services.subtypeofAirCONDITIONINGInBR;
        break;
      case 'DRIVER':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofDriverInENG;
        else
          subTypesList = services.subtypeofDriverInBR;
        break;
      case 'ELECTRICAL':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofElectricalInENG;
        else
          subTypesList = services.subtypeofElectricalInBR;
        break;
      case 'MUSIC':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofMusicInENG;
        else
          subTypesList = services.subtypeofMusicInBR;
        break;
      case 'HYDRAULIC':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofHYDRAULICInENG;
        else
          subTypesList = services.subtypeofHYDRAULICInBR;
        break;
      case 'REFORM':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofREFORMInENG;
        else
          subTypesList = services.subtypeofREFORMInBR;
        break;
      case 'FURNITURE ASSEMBLY':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofFURNITUREASSEMBLYInENG;
        else
          subTypesList = services.subtypeofFURNITUREASSEMBLYInBR;
        break;
      case 'FREIGHT':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofFREIGHTInENG;
        else
          subTypesList = services.subtypeofFREIGHTInBR;
        break;
      case 'TECHNICAL ASSISTANCE':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofTECHNICALASSISTANCEInENG;
        else
          subTypesList = services.subtypeofTECHNICALASSISTANCEInBR;
        break;
      case 'GLASS':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofGLASSInENG;
        else
          subTypesList = services.subtypeofGLASSInBR;
        break;
      case 'MASSAGES AND THERAPIES':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofMAINTENANCEInENG;
        else
          subTypesList = services.subtypeofMAINTENANCEInBR;
        break;
      case 'PARTY ANIMATION':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofPARTYANIMATIONInENG;
        else
          subTypesList = services.subtypeofPARTYANIMATIONInBR;
        break;
      case 'BIKEBOY':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofBIKEBOYInENG;
        else
          subTypesList = services.subtypeofBIKEBOYInBR;
        break;
      case 'LOCKSMITH':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofLOCKSMITHInENG;
        else
          subTypesList = services.subtypeofLOCKSMITHInBR;
        break;
      case 'ELDERLY CAREGIVER':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofELDERLYCAREGIVERInENG;
        else
          subTypesList = services.subtypeofELDERLYCAREGIVERInBR;
        break;
      case 'PHOTOGRAPHER':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofPHOTOGRAPHERInENG;
        else
          subTypesList = services.subtypeofPHOTOGRAPHERInBR;
        break;
      case 'GARDENER':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofGARDENERInENG;
        else
          subTypesList = services.subtypeofGARDENERInBR;
        break;
      case 'CAR WASH':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofCARWASHInENG;
        else
          subTypesList = services.subtypeofCARWASHInBR;
        break;
      case 'PETS':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofPETSInENG;
        else
          subTypesList = services.subtypeofPETSInBR;
        break;
      case 'MANICURE':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofMANICUREInENG;
        else
          subTypesList = services.subtypeofMANICUREInBR;
        break;
      case 'FOOD':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofFOODInENG;
        else
          subTypesList = services.subtypeofFOODInBR;
        break;
      case 'AUTOMOBILES':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofAUTOMOBILESInENG;
        else
          subTypesList = services.subtypeofAUTOMOBILESInBR;
        break;
      case 'MAINTENANCE':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofMAINTENANCEInENG;
        else
          subTypesList = services.subtypeofMAINTENANCEInBR;
        break;
      case 'PERSONAL TRAINER':
        if (_setting.language == 'English')
          subTypesList = services.subtypeofPERSONALTRAINERInENG;
        else
          subTypesList = services.subtypeofPERSONALTRAINERInBR;
        break;
    }
  }
}

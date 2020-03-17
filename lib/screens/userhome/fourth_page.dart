import 'package:flutter/material.dart';
import 'package:liderfacilites/main.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/auth_provider.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/models/strippayment.dart';
import 'package:liderfacilites/screens/editInfo.dart';
import 'package:liderfacilites/screens/login.dart';
import 'package:liderfacilites/screens/controlpanel.dart';
import 'package:liderfacilites/screens/payment/addPayment.dart';
import 'package:liderfacilites/screens/servicespage.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../addservices.dart';

class FourthPage extends StatefulWidget {
  FourthPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FourthPageState();
  }
}

class FourthPageState extends State<FourthPage> {
  TextStyle listTileTitle = TextStyle(color: Colors.black);
  var languages = ['English', 'Portuguese'];
  String language = 'English';
  Setting setting = new Setting();
  //
  String _imageUrl;

  //User is singleton
  User _userData = new User();
  //this value will be assign to tasker button
  String taskerBtnTxt;
  bool taskerTxtVisibility = true;
  //Global applocalization variable;
  AppLocalizations lang;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    language = setting.getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_userData.imageUrl != null) _imageUrl = _userData.imageUrl;
    lang = AppLocalizations.of(context);
    debugPrint('isTasker: ' + _userData.isTasker.toString());
    if (_userData.isTasker) {
      // taskerBtnTxt = AppLocalizations.of(context).translate('Edit My Services');
      taskerTxtVisibility = false;
    } else {
      // taskerBtnTxt = AppLocalizations.of(context).translate('Become a tasker');
      taskerTxtVisibility = true;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(246, 248, 250, 1),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              uperPart(),
              bottomPart(),
            ],
          ),
        ),
      ),
    );
  }

  uperPart() {
    return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 2.4,
            decoration: BoxDecoration(
                color: Color.fromRGBO(26, 119, 186, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: <Widget>[
                logoutTXT(),
                profileImage(),
                userNameTXT(),
                userNumberTxt(),
                editButton(),
              ],
            ),
          ),
        ));
  }

  logoutTXT() {
    return GestureDetector(
        onTap: () {
          debugPrint('logout');
          _signOut(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 15, top: 15),
          child: Align(
            alignment: Alignment.topRight,
            child: Text('Logout',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));
  }

  profileImage() {
    // String _imageUrl;
    return CircleAvatar(
      radius: 40,
      // backgroundColor: Colors.black,
      child: ClipOval(
          child: _imageUrl == null
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
                )),
    );
  }

  userNameTXT() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(_userData.name,
          style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }

  userNumberTxt() {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(_userData.phoneNumber.toString(),
            style: TextStyle(color: Colors.white, fontSize: 18)));
  }

  editButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: OutlineButton(
        onPressed: () {
          navigateToEditPage();
        },
        borderSide: BorderSide(color: Colors.white),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            AppLocalizations.of(context).translate('EditInfo'),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  //bottom part implementation
  bottomPart() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 70),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 1.8,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      navigateToServicePage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15, top: 7),
                      child: ListTile(
                        leading: CircleAvatar(
                          // radius: 20,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.account_circle,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context).translate('My Services'),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: CircleAvatar(
                    // radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.payment,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('My Payments'),
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // navigateToAddPaymentPage();
                    StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest())
                        .then((paymentMethod) {
                          CustomStripePayment.addCard(paymentMethod.id);
                        })
                        .catchError(setError);
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: CircleAvatar(
                    // radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.language,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  title: languageDropDown(),
                  // Text(
                  //   AppLocalizations.of(context).translate('Language'),
                  //   style: TextStyle(color: Colors.black),
                  // ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: CircleAvatar(
                    // radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.settings_system_daydream,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('Control Panel'),
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    navigateToControlPanelPage();
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Visibility(
                    visible: taskerTxtVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        onPressed: () {
                          // debugPrint('become tasker');
                          navigateToAddServicePage();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Color.fromRGBO(26, 119, 186, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lang.translate('Become a tasker'),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  languageDropDown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      items: languages.map((String dropDownStringItem) {
        return DropdownMenuItem(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          language = value;
          Locale newLocale;
          if (language == 'English') {
            newLocale = Locale('en', 'EN');
          } else {
            newLocale = Locale('pt', 'BR');
          }
          // Provider.of<LocaleModel>(context, listen: false).changelocale(newLocale);
          MyApp.setLocale(context, newLocale);
          debugPrint('after setting');
          setting.setLanguageToSP(value);
        });
      },
      value: language,
    ));
  }

  navigateToControlPanelPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ControlPanel(),
      ),
    );
  }

  navigateToAddServicePage() async {
    bool result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddService(),
      ),
    );

    if (result) {
      if (this.mounted) {
        setState(() {
          print('setstate');
        });
      }
    }
  }

  navigateToEditPage() async {
    bool result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => EditInfo(),
      ),
    );

    // if (result) {
    //   if (this.mounted) {
    //     setState(() {
    //       //may be data changed
    //       debugPrint('before img: '+_userData.imageUrl);
    //       _imageUrl = _userData.imageUrl;
    //       debugPrint('after img: '+_userData.imageUrl);
    //     });
    //   }
    // }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();

      //clear user data so when another user login with same phone, no unexpected data open
      _userData.clearUserData();

      //due to some issue, i will navigate to login page manually
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Login();
        },
      ));
    } catch (e) {
      print(e);
    }
  }

  navigateToServicePage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => MyServices(),
      ),
    );
    // Navigator.pushNamed(context,"/servicespage");
  }

  navigateToAddPaymentPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPayment();
    }));
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    // setState(() {
    //   _error = error.toString();
    // });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/screens/userhome/home.dart';
import 'package:liderfacilites/screens/login.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController nameC = new TextEditingController();
  // TextEditingController emailC = new TextEditingController();
  // TextEditingController phoneC = new TextEditingController();
  // TextEditingController pasC = new TextEditingController();
  String _name;
  String _email;
  int _phonenumber;
  String _password;
  //
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              uperPart(),
              nameTF(),
              emailTF(),
              phoneTF(),
              passTF(),
              registerBtn(),
              orText(),
              f_gAccounts(),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                    child: GestureDetector(
                        onTap: () {
                          navigateToLoginPage();
                        },
                        child: RichText(
                          text: TextSpan(
                            // text: 'New user?',
                            text: AppLocalizations.of(context)
                                .translate('Have an account'),
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                // text: ' Sign up',
                                text: AppLocalizations.of(context)
                                    .translate('Login'),
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                              )
                            ],
                          ),
                        ))),
              )
            ],
          ),
        ),
      ),
    ));
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.2,
      decoration: BoxDecoration(
          color: Color.fromRGBO(26, 119, 186, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 150,
                height: 170,
              )),
          Expanded(
              flex: 1,
              child: Text(
                // 'Login',
                AppLocalizations.of(context).translate('Signup'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
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
            // controller: nameC,
            onSaved: (value) {
              _name = value;
            },
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
            // controller: emailC,
            onSaved: (value) {
              _email = value;
            },
            decoration: InputDecoration(
                // hintText: 'Email',
                hintText: AppLocalizations.of(context).translate('Email'),
                border: InputBorder.none,
                fillColor: Colors.blue),
          ),
        ));
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
          // controller: phoneC,
          onSaved: (value) {
            _phonenumber = int.parse(value);
          },
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate('PhoneNumber'),
              border: InputBorder.none,
              fillColor: Colors.blue),
        ),
      ),
    );
  }

  passTF() {
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
            validator: (input) {
              if (input.length < 6) {
                return AppLocalizations.of(context)
                    .translate('Your password need to be atleast 6 characters');
              } else
                return null;
            },
            // controller: pasC,
            onSaved: (value) {
              _password = value;
            },
            obscureText: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('Password'),
                border: InputBorder.none,
                fillColor: Colors.blue),
          ),
        ));
  }

  registerBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.25,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
        child: RaisedButton(
          color: Color.fromRGBO(26, 119, 186, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            //remove cursor blink of search textfield
            FocusScope.of(context).requestFocus(new FocusNode());
            registerUserInFireStore();
          },
          child: Text(
            AppLocalizations.of(context).translate('Signup'),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  orText() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.35,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.black26,
              height: 45,
              thickness: 2,
            ),
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  // 'OR',
                  AppLocalizations.of(context).translate('OR'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black26),
                ),
              )),
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.black26,
              height: 45,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }

  f_gAccounts() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.25,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 8,
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  signInWithFacebook();
                },
                child: Text(
                  'Facebook',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.blueAccent),
                ),
              )),
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 8,
              child: RaisedButton(
                padding: EdgeInsets.all(13),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  signInWithGoogle();
                },
                child: Text(
                  'Google',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.redAccent),
                ),
              )),
        ],
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return AppLocalizations.of(context).translate('Enter Valid Email');
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

  navigateToLoginPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  registerUserInFireStore() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseUser user;
      try {
        await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((authData) => {
                  createRecord(authData),
                  user = authData.user,
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => HomePage(user.uid)))
                })
            .catchError((e) => {print(e.toString())});
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void createRecord(AuthResult authData) async {
    await db.collection("users").document(authData.user.uid).setData({
      'name': _name,
      'email': _email,
      'phonenumber': _phonenumber,
      'password': _password,
      'istasker': false,
      'favourite': [],
      'booking': [],
      'requests': [],
    });

    // DocumentReference ref = await databaseReference.collection("books")
    //     .add({
    //       'title': 'Flutter in Action',
    //       'description': 'Complete Programming Guide to learn Flutter'
    //     });
    // print(ref.documentID);
  }

  void signInWithGoogle() async {
    BaseAuth auth = new Auth();
    String uid = await auth.signInWithGoogle();
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => HomePage(uid)));
  }

  void signInWithFacebook() async {
    BaseAuth auth = new Auth();
    String uid = await auth.signInWithFacebook();
    print('facebook uid: ' + uid);
    if (uid != 'canceled' && uid != 'error' && uid != null) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage(uid)));
    }
  }
}

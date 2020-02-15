import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/screens/home.dart';
import 'package:liderfacilites/screens/register.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController emailC = new TextEditingController();
  // TextEditingController pasC = new TextEditingController();
  String _email;
  String _pass;
  //error visiblity
  bool errorVisibility = false;

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
              emailTF(),
              passTF(),
              loginBtn(),
              errorMessage(),
              orText(),
              fgAccounts(),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: Center(
                    child: GestureDetector(
                        onTap: () {
                          navigateToRegisterPage();
                        },
                        child: RichText(
                          text: TextSpan(
                            // text: 'New user?',
                            text: AppLocalizations.of(context)
                                .translate('Newuser'),
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                // text: ' Sign up',
                                text: AppLocalizations.of(context)
                                    .translate('Signup'),
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
                AppLocalizations.of(context).translate('Login'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  emailTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
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
            )
          ],
        ),
      ),
    );
  }

  passTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
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
                validator: validatePassword,
                // controller: pasC,
                obscureText: true,
                onSaved: (value) {
                  _pass = value;
                },
                decoration: InputDecoration(
                    // hintText: 'Password',
                    hintText:
                        AppLocalizations.of(context).translate('Password'),
                    border: InputBorder.none,
                    fillColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  loginBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
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
            validateUser();
          },
          child: Text(
            // 'Login',
            AppLocalizations.of(context).translate('Login'),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  errorMessage() {
    return Visibility(
        visible: errorVisibility,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              'Invalid Email or Password',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ));
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

  fgAccounts() {
    return Padding(
      padding: EdgeInsets.only(top: 1.0),
      child: Container(
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
                    onPressed: () {},
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
                    onPressed: () {},
                    child: Text(
                      'Google',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.redAccent),
                    ),
                  )),
            ],
          )),
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

  String validatePassword(String valule) {
    if (valule.length < 6) {
      return AppLocalizations.of(context)
          .translate('Your password need to be atleast 6 characters');
    } else
      return null;
  }

  void navigateToRegisterPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Register();
    }));
  }

  void validateUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _pass);
        FirebaseUser user = result.user;
        if (user.uid != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        } else {
          setState(() {
            errorVisibility = true;
          });
          print('error');
        }
      } catch (e) {
        setState(() {
          errorVisibility = true;
        });
        print(e.toString());
      }
    }
  }
}

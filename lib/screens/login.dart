import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              uperPart(),
              emailTF(),
              passTF(),
              loginBtn(),
              orText(),
              f_gAccounts(),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: 'New user?',
                    style: TextStyle(color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Sign up',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                      )
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
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
                'Login',
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
              child: TextField(
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'Email',
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
              child: TextField(
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'Password',
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
          onPressed: () {},
          child: Text(
            'Login',
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
                  'OR',
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
}

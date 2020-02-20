import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/screens/addservices.dart';

class MyServices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyServicesState();
  }
}

class MyServicesState extends State<MyServices> {
  User user = new User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: myServiceBody(context));
  }

  myServiceBody(BuildContext context) {
    if (!user.isTasker) {
      return noServiceBody(context);
    } else {
      //return service body
    }
  }

  noServiceBody(BuildContext context) {
    return Column(
      children: <Widget>[
        uperPart(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.height / 3.2,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: new AssetImage('assets/images/noservice.png'),
                // fit: BoxFit.fill
              ),
              shape: BoxShape.circle,
            ),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
              child: Text(
                  AppLocalizations.of(context)
                      .translate("You don't have any service"),
                  style: TextStyle(fontSize: 18))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Center(
              child: Text(
                  AppLocalizations.of(context).translate(
                      "If you wanna add a new one you have to be a tasker first"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: RaisedButton(
            onPressed: () {
              debugPrint('become tasker');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Color.fromRGBO(26, 119, 186, 1),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10),
              child: Text(
                AppLocalizations.of(context).translate('Become a tasker'),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  uperPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
          color: Color.fromRGBO(26, 119, 186, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(AppLocalizations.of(context).translate('My Services'),
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                navigateToAddServicePage();
              },
              child: Text(AppLocalizations.of(context).translate('Add New'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  navigateToAddServicePage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddService(),
      ),
    );
  }
}

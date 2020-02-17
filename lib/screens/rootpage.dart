import 'package:flutter/material.dart';
import 'package:liderfacilites/models/auth_provider.dart';
import 'package:liderfacilites/models/authentication.dart';
import 'package:liderfacilites/screens/home.dart';
import 'package:liderfacilites/screens/login.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          final bool isLoggedIn = snapshot.hasData;
          // String data = snapshot.data;
          // debugPrint('data: '+data.toString());
          return isLoggedIn ? HomePage(snapshot.data) : Login();
        }
        return _buildWaitingScreen(context);
        //should return splash screen here
      },
    );
  }

  Widget _buildWaitingScreen(BuildContext context) {
    return Center(
        child: Container(
      height: 170.0,
      width: 170.0,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('assets/images/logo.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    ));
  }

}
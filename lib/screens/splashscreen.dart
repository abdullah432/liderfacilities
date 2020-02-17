import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) {
    //       return RootPage();
    //     }));
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 119, 186, 1),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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

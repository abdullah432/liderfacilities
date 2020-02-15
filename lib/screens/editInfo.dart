import 'package:flutter/material.dart';

class EditInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditInfoState();
  }
}

class EditInfoState extends State<EditInfo> {
  String _imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Column(
      children: <Widget>[
      imageView(),
    ],),));
  }

  imageView(){
    return CircleAvatar(radius: 50, child:_imageUrl == null ? Image.asset('assets/images/account.png',)
                :Image.network(_imageUrl,fit: BoxFit.cover),);
  }
}
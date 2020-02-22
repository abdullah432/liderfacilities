import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liderfacilites/models/User.dart';

class CustomFirestore {
  User _user = new User();
  final db = Firestore.instance;
  Future<bool> createServiceRecord(
      String type, String subtype, String hourlyrate, String desc) async {
    try {
      await db.collection("services").add({
        'type': type,
        'subtype': subtype,
        'hourlyrate': hourlyrate,
        'description': desc,
        'reference': db.collection('users').document(_user.uid),
        'imgurl': _user.imageUrl,
        'taskername': _user.name
      }).whenComplete((){
        return true;
      }).catchError((onError){
        print('error during adding service: '+onError.toString());
        return false;
      });
    } catch (e) {
      print('exception during adding service: '+e.toString());
      return false;
    }
    return true;
  }

  updateToTasker(){
    db.collection('users').document(_user.uid).updateData(({
      'istasker': true
    }));
  }

  
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';

class CustomFirestore {
  User _user = new User();
  final db = Firestore.instance;

  Future<bool> createServiceRecord(
      String type,
      String subtype,
      String hourlyrate,
      String desc,
      String serviceImgUrl,
      GeoPoint geoPoint) async {
    try {
      await db.collection("services").add({
        'type': type,
        'subtype': subtype,
        'hourlyrate': hourlyrate,
        'description': desc,
        'reference': db.collection('users').document(_user.uid),
        'imgurl': _user.imageUrl,
        'taskername': _user.name,
        'serviceimageurl': serviceImgUrl,
        'geopoint': geoPoint
      }).whenComplete(() {
        return true;
      }).catchError((onError) {
        print('error during adding service: ' + onError.toString());
        return false;
      });
    } catch (e) {
      print('exception during adding service: ' + e.toString());
      return false;
    }
    return true;
  }

  updateToTasker() {
    db.collection('users').document(_user.uid).updateData(({'istasker': true}));
  }

  //add reference of service when user like a service
  addServiceToFavourit(ref) {
    db.collection('users').document(_user.uid).updateData(({
          'favourite': FieldValue.arrayUnion([ref])
        }));
  }

  //add reference of service when user like a service
  removeServiceFromFavourite(ref) {
    db.collection('users').document(_user.uid).updateData(({
          'favourite': FieldValue.arrayRemove([ref])
        }));
  }

  Future<List<DocumentSnapshot>> getAllTasker() async {
    DocumentReference docRef = db.collection('users').document(_user.uid);
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("services")
        .where('reference', isEqualTo: docRef)
        .getDocuments();
    var list = querySnapshot.documents;
    return list;
    // return querySnapshot.documents;
    // return list;
  }

  Future<User> loadUserData() async {
    var snapshot = await db.collection('users').document(_user.uid).get();
    User userRecord = User.fromSnapshot(snapshot);
    _user.setUID(_user.uid);
    _user.setname(userRecord.name);
    _user.setEmail(userRecord.email);
    _user.setPhoneNum(userRecord.phoneNumber);
    _user.setUserState(userRecord.isTasker);
    if (userRecord.imageUrl != null) _user.setImageUrl(userRecord.imageUrl);
    if (userRecord.socialsecurity != null)
      _user.setSocialSecurity(userRecord.socialsecurity);
    if (userRecord.reg != null) _user.setReg(userRecord.reg);
    if (userRecord.address != null) _user.setAddress(userRecord.address);
    if (userRecord.geopoint != null) _user.setGeoPoint(userRecord.geopoint);

    return userRecord;
  }

  Future<List<DocumentSnapshot>> loadFavServices() async {
    print('loadfavservices called');
      List<String> favouriteList = _user.favoriteList;
      List<DocumentSnapshot> documentSnapshot = new List();
      for (int i = 0; i < favouriteList.length; i++) {
        var snapshot =
            await db.collection('services').document(favouriteList[i]).get();

        documentSnapshot.add(snapshot);
      }
      debugPrint('length of ds: ' + documentSnapshot.length.toString());
      return documentSnapshot;
  }

  //add payment collection to firestore
  addNewPaymentMethod(nameoncard, cardnum, expiryDate, cvv) async {
    String result;
    try {
      await db
          .collection('users')
          .document(_user.uid)
          .collection('payment')
          .add({
            'nameoncard': nameoncard,
            'cardnumber': cardnum,
            'expirydate': expiryDate,
            'cvv': cvv
          })
          .then((value) => {
                result = 'Payment Method added successfully',
              })
          .timeout(Duration(seconds: 10))
          .catchError((error) {
            print("doc save error");
            print(error);
            result = error.toString();
          });
    } catch (e) {
      print('exception: ' + e.toString());
      result = e.toString();
    }
  }
}

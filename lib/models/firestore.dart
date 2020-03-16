import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liderfacilites/models/User.dart';
import 'package:liderfacilites/models/booking.dart';

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

  // Future<List<DocumentSnapshot>> loadAllUsersData() {
  //   List<DocumentSnapshot> documentSnapshot = new List();
  // }

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

  Future<List<DocumentSnapshot>> loadBooking() async {
    print('load booking called');
    List<String> _bookingList = _user.bookingList;
    List<DocumentSnapshot> documentSnapshot = new List();
    for (int i = 0; i < _bookingList.length; i++) {
      var snapshot =
          await db.collection('book').document(_bookingList[i]).get();

      documentSnapshot.add(snapshot);
      print(documentSnapshot[i].documentID.toString());
    }
    return documentSnapshot;
  }

  Future<List<DocumentSnapshot>> loadAllRequests() async {
    print('load requests called');
    List<String> requestsList = _user.requestList;
    List<DocumentSnapshot> documentSnapshot = new List();
    for (int i = 0; i < requestsList.length; i++) {
      var snapshot =
          await db.collection('book').document(requestsList[i]).get();

      print('id: ' + requestsList[i].toString());

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

  void deletePaymentMethod(deleteUid) {
    try {
      db
          .collection('users')
          .document(_user.uid)
          .collection('payment')
          .document(deleteUid)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //add booking collection to firestore
  addNewbooking(
      bookby, bookto, paymentuid, price, imageurl, type, subtype) async {
    String result;
    try {
      await db
          .collection('book')
          .add({
            'bookby': bookby,
            'bookto': bookto,
            'paymentuid': paymentuid,
            'price': price,
            'imageurl': imageurl,
            'type': type,
            'subtype': subtype,
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

  bookingHistroy(bookID, taskerid) {
    print('booking histroy');
    print('useruid: ' + _user.uid);
    print('taskeruid: ' + taskerid);
    try {
      //add book array to users
      db.collection('users').document(_user.uid).updateData({
        'booking': FieldValue.arrayUnion([bookID])
      }).catchError((error) {
        print("doc save error");
        print(error);
      });
      //add request array to tasker
      db.collection('users').document(taskerid).updateData({
        'requests': FieldValue.arrayUnion([bookID])
      }).catchError((error) {
        print("doc save error");
        print(error);
      });
    } catch (e) {
      print('exception: ' + e.toString());
    }
  }

  checkBookingTiming() async {
    if (_user.bookingList != null) {
      var now = new DateTime.now();
      // // var cutoff = now.millisecond - 2 * 60 * 60 * 1000;
      // print('now: '+now.toString());
      // print('cutoff: '+cutoff.toString());
      List<String> _bookingList = _user.bookingList;
      List<Booking> bookingList = new List();
      for (int i = 0; i < _bookingList.length; i++) {
        var snapshot =
            await db.collection('book').document(_bookingList[i]).get();

        var record = Booking.fromSnapshot(snapshot);
        bookingList.add(record);
      }

      for (int i = 0; i < bookingList.length; i++) {
        var timestamp = bookingList[i].timestamp;
        // var format = DateFormat('HH:mm a');
        var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        var diff = now.difference(date);
        // var time = '';
        // final inMinutes = now.difference(date).inMinutes;
        // print('dateutc: '+date.toUtc().toString());
        // print('date: '+date.toString());
        // print('minutes: '+inMinutes.toString());
        // print ('diff: '+diff.inMinutes.toString());
        if (diff.inMinutes >= 13) {
          // time = format.format(date);
          print('greater than 13');
          print('doc: ' + bookingList[i].reference.documentID);
          //if greater than 13 than change status to 'Tasker not respond'
          try {
            db
                .collection('book')
                .document(_bookingList[i])
                .updateData({'state': 'Tasker fail to respond'});
          } catch (e) {
            print('Exception: ' + e);
          }
        } else {
          print('less than 13');
          //  time = format.format(date);
        }
      }
    } else {
      print('booking is null');
    }
  }

  cancelRequest(id) {
    print('id: '+id);
    try {
      db.collection('book').document(id).updateData({'state': 'Rejected'});
    } catch (e) {
      print('Exception: ' + e);
    }
  }

  acceptRequest(id) {
    print('id: '+id);
    try {
      db.collection('book').document(id).updateData({'state': 'Accepted'});
    } catch (e) {
      print('Exception: ' + e);
    }
  }
}

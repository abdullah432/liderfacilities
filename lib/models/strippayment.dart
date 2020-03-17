import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomStripePayment {
  static addCard(token) {
    FirebaseAuth.instance.currentUser().then((user) => {
      Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('tokens')
        .add({'tokenId': token}).then((value) => {
          print('token added successfully')
        })
    });
  }
}
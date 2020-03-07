import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  // String _nameOnCard;
  String _cardNumber;
  String _expiryDate;
  // int _cvv;
  DocumentReference reference;

  //singleton logic
  static final Payment payment = Payment._internal();
  Payment._internal();
  factory Payment() {
    return payment;
  }

  //assert mean these fields are manditory, other can be null
  Payment.fromMap(Map<String, dynamic> map, {this.reference})
      : 
      // assert(map['nameoncard'] != null),
        assert(map['cardnumber'] != null),
        assert(map['expirydate'] != null),
        _cardNumber = map['cardnumber'],
        _expiryDate = map['expirydate'];

  Payment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  get cardnumber {
    return _cardNumber;
  }

  get expirydate {
    return _expiryDate;
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String _name;
  final String _email;
  final int _phonenumber;
  final String _imageUrl;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['email'] != null),
        assert(map['phonenumber'] != null),
        assert(map['imageurl'] != null),
        _name = map['name'],
        _email = map['email'],
        _phonenumber = map['phonenumber'],
        _imageUrl = map['imageurl'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  get name {
    return _name;
  }

  get email {
    return _email;
  }

  get phoneNumber {
    return _phonenumber;
  }

  get imageUrl {
    return _imageUrl;
  }
}

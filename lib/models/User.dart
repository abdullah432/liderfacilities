import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _name;
  String _email;
  int _phonenumber;
  String _imageUrl;
  var _uid;
  bool _isTasker;
  DocumentReference reference;

  //singleton logic
  static final User user = User._internal();
  User._internal();
  factory User() {
    return user;
  }

  //assert mean these fields are manditory, other can be null
  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['email'] != null),
        assert(map['phonenumber'] != null),
        // assert(map['imageurl'] != null),
        _name = map['name'],
        _email = map['email'],
        _phonenumber = map['phonenumber'],
        _imageUrl = map['imageurl'],
        _isTasker = map['istasker'];

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

  get uid {
    return _uid;
  }

  get isTasker {
    return _isTasker;
  }

  void setname(String value) {
    this._name = value;
  }

  void setEmail(String value) {
    this._email = value;
  }

  void setPhoneNum(int value) {
    this._phonenumber = value;
  }

  void setImageUrl(String value) {
    this._imageUrl = value;
  }

  void setUID(var value) {
    this._uid = value;
  }

  void setUserState(bool value) {
    this._isTasker = value;
  }
}

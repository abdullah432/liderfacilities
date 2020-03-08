import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String _name;
  String _bookby;
  String _type;
  String _subtype;
  var _uid;
  String _price;
  String _imageurl;
  String _state;
  var _timestamp;
  // GeoPoint _geoPoint;
  DocumentReference reference;

  //singleton logic
  static final Booking booking = Booking._internal();
  Booking._internal();
  factory Booking() {
    return booking;
  }

  //assert mean these fields are manditory, other can be null
  Booking.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        assert(map['subtype'] != null),
        assert(map['price'] != null),
        _name = map['name'],
        _bookby = map['bookby'],
        _type = map['type'],
        _subtype = map['subtype'],
        _price = map['price'],
        _imageurl = map['imageurl'],
        _state = map['state'],
        _timestamp = map['timestamp'];

  Booking.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  get type {
    return _type;
  }

  get subtype {
    return _subtype;
  }

  get uid {
    return _uid;
  }

  get imageurl {
    return _imageurl;
  }

  get price {
    return _price;
  }

  get state {
    return _state;
  }

  get name {
    return _name;
  }

  get bookby {
    return _bookby;
  }

  get timestamp {
    return _timestamp;
  }

  // get geopoint {
  //   return _geoPoint;
  // }


  void settype(String value) {
    this._type = value;
  }

  void setImageUrl(String value) {
    this._imageurl = value;
  }

  void setUID(var value) {
    this._uid = value;
  }

  void setSubType(String value) {
    this._subtype = value;
  }

  void setprice(String value) {
    this._price = value;
  }

  void setstate(String value) {
    this._state = value;
  }

  void settimestamp(String value) {
    this._timestamp = value;
  }

  // void setGeopoint(GeoPoint value) {
  //   this._geoPoint = value;
  // }
}

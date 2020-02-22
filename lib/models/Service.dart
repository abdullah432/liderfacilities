import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String _name;
  String _imgUrl;
  String _description;
  String _typeofservice;
  String _subservice;
  var _uid;
  String _hourlyrate;
  DocumentReference reference;

  //singleton logic
  static final Service service = Service._internal();
  Service._internal();
  factory Service() {
    return service;
  }

  //assert mean these fields are manditory, other can be null
  Service.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['taskername'] != null),
        assert(map['description'] != null),
        assert(map['type'] != null),
        assert(map['subtype'] != null),
        assert(map['hourlyrate'] != null),
        _name = map['taskername'],
        _description = map['description'],
        _typeofservice = map['type'],
        _subservice = map['subtype'],
        _imgUrl = map['imgurl'],
        _hourlyrate = map['hourlyrate'];

  Service.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  get name {
    return _name;
  }

  get description {
    return _description;
  }

  get typeofservice {
    return _typeofservice;
  }

  get subtype {
    return _subservice;
  }

  get uid {
    return _uid;
  }

  get imageurl {
    return _imgUrl;
  }

  get hourlyrate {
    return _hourlyrate;
  }

  void setname(String value) {
    this._name = value;
  }

  void setDescription(String value) {
    this._description = value;
  }

  void settype(String value) {
    this._typeofservice = value;
  }

  void setImageUrl(String value) {
    this._imgUrl = value;
  }

  void setUID(var value) {
    this._uid = value;
  }

  void setSubType(String value) {
    this._subservice = value;
  }
}

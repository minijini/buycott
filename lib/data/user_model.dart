class UserModel {
  UserModel({
    String? userId,
    String? userName,
    String? nickname,
    String? email,
    String? address,
    String? pushYn,
    String? signType,
  }) {
    _userId = userId;
    _userName = userName;
    _nickname = nickname;
    _email = email;
    _address = address;
    _pushYn = pushYn;
    _signType = signType;
  }

  UserModel.fromJson(dynamic json) {
    _userId = json['userId'];
    _userName = json['userName'];
    _nickname = json['nickname'];
    _email = json['email'];
    _address = json['address'];
    _pushYn = json['pushYn'];
    _signType = json['signType'];
  }

  String? _userId;
  String? _userName;
  String? _nickname;
  String? _email;
  String? _address;
  String? _pushYn;
  String? _signType;

  String? get userId => _userId;

  String? get userName => _userName;

  String? get nickname => _nickname;

  String? get email => _email;

  String? get address => _address;

  String? get pushYn => _pushYn;
  String? get signType => _signType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['userName'] = _userName;
    map['nickname'] = _nickname;
    map['email'] = _email;
    map['address'] = _address;
    map['pushYn'] = _pushYn;
    map['signType'] = _signType;
    return map;
  }
}

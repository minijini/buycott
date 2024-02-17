class ResultModel {
  ResultModel({
    String? token,
    int? userSrno,
    int? code,
    String? msg,
    String? signedUrl,
    dynamic body,
  }) {
    _token = token;
    _userSrno = userSrno;
    _code = code;
    _msg = msg;
    _signedUrl = signedUrl;
    _body = body;
  }

  ResultModel.fromJson(dynamic json) {
    _token = json['token'];
    _userSrno = json['userSrno'];
    _code = json['code'];
    _msg = json['msg'];
    _signedUrl = json['signedUrl'];
    _body = json['body'];
  }

  String? _token;
  int? _userSrno;
  int? _code;
  String? _msg;
  String? _signedUrl;
  dynamic _body;

  String? get token => _token;

  int? get userSrno => _userSrno;

  int? get code => _code;

  String? get msg => _msg;

  String? get signedUrl => _signedUrl;
  dynamic get body => _body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['userSrno'] = _userSrno;
    map['code'] = _code;
    map['msg'] = _msg;
    map['signedUrl'] = _signedUrl;
    map['body'] = _body;
    return map;
  }
}

class ResultModel {
  ResultModel({
      String? token,
    int? userSrno,
    int? code,
      String? msg,
      String? signedUrl,
  }){
    _token = token;
    _userSrno = userSrno;
    _code = code;
    _msg = msg;
    _signedUrl = signedUrl;
}

  ResultModel.fromJson(dynamic json) {
    _token = json['token'];
    _userSrno = json['userSrno'];
    _code = json['code'];
    _msg = json['msg'];
    _signedUrl = json['signedUrl'];
  }
  String? _token;
  int? _userSrno;
  int? _code;
  String? _msg;
  String? _signedUrl;

  String? get token => _token;
  int? get userSrno => _userSrno;
  int? get code => _code;
  String? get msg => _msg;
  String? get signedUrl => _signedUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['userSrno'] = _userSrno;
    map['code'] = _code;
    map['msg'] = _msg;
    map['signedUrl'] = _signedUrl;
    return map;
  }

}
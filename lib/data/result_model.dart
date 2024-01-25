class ResultModel {
  ResultModel({
      String? token,
    int? userSrno,
    int? code,
      String? msg,}){
    _token = token;
    _userSrno = userSrno;
    _code = code;
    _msg = msg;
}

  ResultModel.fromJson(dynamic json) {
    _token = json['token'];
    _userSrno = json['userSrno'];
    _code = json['code'];
    _msg = json['msg'];
  }
  String? _token;
  int? _userSrno;
  int? _code;
  String? _msg;

  String? get token => _token;
  int? get userSrno => _userSrno;
  int? get code => _code;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['userSrno'] = _userSrno;
    map['code'] = _code;
    map['msg'] = _msg;
    return map;
  }

}
/// os : "A"
/// appVserion : "1.0"
/// minVersion : "1.0"
/// forceYn : "Y"

class AppversionModel {
  AppversionModel({
      String? os,
      String? appVersion,
      String? minVersion,
      String? forceYn,}){
    _os = os;
    _appVersion = appVersion;
    _minVersion = minVersion;
    _forceYn = forceYn;
}

  AppversionModel.fromJson(dynamic json) {
    _os = json['os'];
    _appVersion = json['appVersion'];
    _minVersion = json['minVersion'];
    _forceYn = json['forceYn'];
  }
  String? _os;
  String? _appVersion;
  String? _minVersion;
  String? _forceYn;

  String? get os => _os;
  String? get appVersion => _appVersion;
  String? get minVersion => _minVersion;
  String? get forceYn => _forceYn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['os'] = _os;
    map['appVersion'] = _appVersion;
    map['minVersion'] = _minVersion;
    map['forceYn'] = _forceYn;
    return map;
  }

}
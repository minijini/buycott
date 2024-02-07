class StoreModel {
  StoreModel({
    String? apiId,
    String? storeType,
    String? storeTypeNm,
    String? storeAddress,
    String? storeName,
    String? storePhone,
    String? storeDesc,
    double? x,
    double? y,
  }) {
    _apiId = apiId;
    _storeType = storeType;
    _storeTypeNm = storeTypeNm;
    _storeAddress = storeAddress;
    _storeName = storeName;
    _storePhone = storePhone;
    _storeDesc = storeDesc;
    _x = x;
    _y = y;
  }

  StoreModel.fromJson(dynamic json) {
    _apiId = json['apiId'];
    _storeType = json['storeType'];
    _storeTypeNm = json['storeTypeNm'];
    _storeAddress = json['storeAddress'];
    _storeName = json['storeName'];
    _storePhone = json['storePhone'];
    _storeDesc = json['storeDesc'];
    _x = json['x'];
    _y = json['y'];
  }

  String? _apiId;
  String? _storeType;
  String? _storeTypeNm;
  String? _storeAddress;
  String? _storeName;
  String? _storePhone;
  String? _storeDesc;
  double? _x;
  double? _y;


  String? get apiId => _apiId;
  String? get storeType => _storeType;
  String? get storeTypeNm => _storeTypeNm;
  String? get storeAddress => _storeAddress;
  String? get storeName => _storeName;
  String? get storePhone => _storePhone;
  String? get storeDesc => _storeDesc;
  double? get x => _x;
  double? get y => _y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['apiId'] = _apiId;
    map['storeType'] = _storeType;
    map['storeTypeNm'] = _storeTypeNm;
    map['storeAddress'] = _storeAddress;
    map['storeName'] = _storeName;
    map['storePhone'] = _storePhone;
    map['storeDesc'] = _storeDesc;
    map['x'] = _x;
    map['y'] = _y;
    return map;
  }
}

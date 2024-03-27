/// storeSrno : 1
/// storeType : "CE7"
/// storeAddress : "서울 마포구 월드컵로1길 14 스타벅스 합정점"
/// storeLoc : {"x":126.9121929350555,"y":37.5499934909868}
/// storeName : "스타벅스 합정점"
/// distance : 0

class StoreModel {
  StoreModel({
    int? storeSrno,
    String? storeType,
    String? storeAddress,
    StoreLoc? storeLoc,
    String? storeName,
    int? distance,
    String? storeTypeNm,
    int? score,
    int? code,
    int? reviewCnt,
    String? storeDesc,
    String? businessHours,
    String? watchYn,
    String? storePhone,
    String? validYn,
  }) {
    _storeSrno = storeSrno;
    _storeType = storeType;
    _storeAddress = storeAddress;
    _storeLoc = storeLoc;
    _storeName = storeName;
    _distance = distance;
    _storeTypeNm = storeTypeNm;
    _score = score;
    _code = code;
    _reviewCnt = reviewCnt;
    _storeDesc = storeDesc;
    _businessHours = businessHours;
    _watchYn = watchYn;
    _storePhone = storePhone;
    _validYn = validYn;
  }

  StoreModel.fromJson(dynamic json) {
    _storeSrno = json['storeSrno'];
    _storeType = json['storeType'];
    _storeAddress = json['storeAddress'];
    _storeLoc =
        json['storeLoc'] != null ? StoreLoc.fromJson(json['storeLoc']) : null;
    _storeName = json['storeName'];
    _distance = json['distance'];
    _storeTypeNm = json['storeTypeNm'];
    _score = json['score'];
    _code = json['code'];
    _reviewCnt = json['reviewCnt'];
    _storeDesc = json['storeDesc'];
    _businessHours = json['businessHours'];
    _watchYn = json['watchYn'];
    _storePhone = json['storePhone'];
    _validYn = json['validYn'];
  }

  int? _storeSrno;
  String? _storeType;
  String? _storeAddress;
  StoreLoc? _storeLoc;
  String? _storeName;
  int? _distance;
  String? _storeTypeNm;
  int? _score;
  int? _code;
  int? _reviewCnt;
  String? _storeDesc;
  String? _businessHours;
  String? _watchYn;
  String? _storePhone;
  String? _validYn;

  int? get storeSrno => _storeSrno;

  String? get storeType => _storeType;

  String? get storeAddress => _storeAddress;

  StoreLoc? get storeLoc => _storeLoc;

  String? get storeName => _storeName;
  String? get businessHours => _businessHours;

  int? get distance => _distance;
  int? get reviewCnt => _reviewCnt;

  String? get storeTypeNm => _storeTypeNm;
  String? get storeDesc => _storeDesc;
  String? get watchYn => _watchYn;
  String? get storePhone => _storePhone;
  String? get validYn => _validYn;

  int? get score => _score;

  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['storeSrno'] = _storeSrno;
    map['storeType'] = _storeType;
    map['storeAddress'] = _storeAddress;
    if (_storeLoc != null) {
      map['storeLoc'] = _storeLoc!.toJson();
    }
    map['storeName'] = _storeName;
    map['distance'] = _distance;
    map['storeTypeNm'] = _storeTypeNm;
    map['score'] = _score;
    map['code'] = _code;
    map['reviewCnt'] = _reviewCnt;
    map['businessHours'] = _businessHours;
    map['storeDesc'] = _storeDesc;
    map['watchYn'] = _watchYn;
    map['storePhone'] = _storePhone;
    map['validYn'] = _validYn;
    return map;
  }
}

/// x : 126.9121929350555
/// y : 37.5499934909868

class StoreLoc {
  StoreLoc({
    double? x,
    double? y,
  }) {
    _x = x;
    _y = y;
  }

  StoreLoc.fromJson(dynamic json) {
    _x = json['x'];
    _y = json['y'];
  }

  double? _x;
  double? _y;

  double? get x => _x;

  double? get y => _y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = _x;
    map['y'] = _y;
    return map;
  }
}

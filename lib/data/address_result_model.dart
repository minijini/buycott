class AddressResultModel {
  AddressResultModel({
      List<Documents>? documents,
      Meta? meta,}){
    _documents = documents;
    _meta = meta;
}

  AddressResultModel.fromJson(dynamic json) {
    if (json['documents'] != null) {
      _documents = [];
      json['documents'].forEach((v) {
        _documents!.add(Documents.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<Documents>? _documents;
  Meta? _meta;

  List<Documents>? get documents => _documents;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_documents != null) {
      map['documents'] = _documents!.map((v) => v.toJson()).toList();
    }
    if (_meta != null) {
      map['meta'] = _meta!.toJson();
    }
    return map;
  }

}


class Meta {
  Meta({
      bool? isEnd,
       int? pageableCount,
       int? totalCount,}){
    _isEnd = isEnd;
    _pageableCount = pageableCount;
    _totalCount = totalCount;
}

  Meta.fromJson(dynamic json) {
    _isEnd = json['is_end'];
    _pageableCount = json['pageable_count'];
    _totalCount = json['total_count'];
  }
  bool? _isEnd;
   int? _pageableCount;
   int? _totalCount;

  bool? get isEnd => _isEnd;
   int? get pageableCount => _pageableCount;
   int? get totalCount => _totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_end'] = _isEnd;
    map['pageable_count'] = _pageableCount;
    map['total_count'] = _totalCount;
    return map;
  }

}


class Documents {
  Documents({
      Address? address,
      String? addressName,
      String? addressType,
      RoadAddress? roadAddress,
      String? x,
      String? y,}){
    _address = address;
    _addressName = addressName;
    _addressType = addressType;
    _roadAddress = roadAddress;
    _x = x;
    _y = y;
}

  Documents.fromJson(dynamic json) {
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
    _addressName = json['address_name'];
    _addressType = json['address_type'];
    _roadAddress = json['road_address'] != null ? RoadAddress.fromJson(json['road_address']) : null;
    _x = json['x'];
    _y = json['y'];
  }
  Address? _address;
  String? _addressName;
  String? _addressType;
  RoadAddress? _roadAddress;
  String? _x;
  String? _y;

  Address? get address => _address;
  String? get addressName => _addressName;
  String? get addressType => _addressType;
  RoadAddress? get roadAddress => _roadAddress;
  String? get x => _x;
  String? get y => _y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_address != null) {
      map['address'] = _address!.toJson();
    }
    map['address_name'] = _addressName;
    map['address_type'] = _addressType;
    if (_roadAddress != null) {
      map['road_address'] = _roadAddress!.toJson();
    }
    map['x'] = _x;
    map['y'] = _y;
    return map;
  }

}

/// address_name : "서울 중랑구 중랑천로 30"
/// building_name : "25시슈퍼"
/// main_building_no : "30"
/// region_1depth_name : "서울"
/// region_2depth_name : "중랑구"
/// region_3depth_name : "면목동"
/// road_name : "중랑천로"
/// sub_building_no : ""
/// underground_yn : "N"
/// x : "127.073923291346"
/// y : "37.588016624798"
/// zone_no : "02132"

class RoadAddress {
  RoadAddress({
      String? addressName,
      String? buildingName,
      String? mainBuildingNo,
      String? region1depthName,
      String? region2depthName,
      String? region3depthName,
      String? roadName,
      String? subBuildingNo,
      String? undergroundYn,
      String? x,
      String? y,
      String? zoneNo,}){
    _addressName = addressName;
    _buildingName = buildingName;
    _mainBuildingNo = mainBuildingNo;
    _region1depthName = region1depthName;
    _region2depthName = region2depthName;
    _region3depthName = region3depthName;
    _roadName = roadName;
    _subBuildingNo = subBuildingNo;
    _undergroundYn = undergroundYn;
    _x = x;
    _y = y;
    _zoneNo = zoneNo;
}

  RoadAddress.fromJson(dynamic json) {
    _addressName = json['address_name'];
    _buildingName = json['building_name'];
    _mainBuildingNo = json['main_building_no'];
    _region1depthName = json['region_1depth_name'];
    _region2depthName = json['region_2depth_name'];
    _region3depthName = json['region_3depth_name'];
    _roadName = json['road_name'];
    _subBuildingNo = json['sub_building_no'];
    _undergroundYn = json['underground_yn'];
    _x = json['x'];
    _y = json['y'];
    _zoneNo = json['zone_no'];
  }
  String? _addressName;
  String? _buildingName;
  String? _mainBuildingNo;
  String? _region1depthName;
  String? _region2depthName;
  String? _region3depthName;
  String? _roadName;
  String? _subBuildingNo;
  String? _undergroundYn;
  String? _x;
  String? _y;
  String? _zoneNo;

  String? get addressName => _addressName;
  String? get buildingName => _buildingName;
  String? get mainBuildingNo => _mainBuildingNo;
  String? get region1depthName => _region1depthName;
  String? get region2depthName => _region2depthName;
  String? get region3depthName => _region3depthName;
  String? get roadName => _roadName;
  String? get subBuildingNo => _subBuildingNo;
  String? get undergroundYn => _undergroundYn;
  String? get x => _x;
  String? get y => _y;
  String? get zoneNo => _zoneNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address_name'] = _addressName;
    map['building_name'] = _buildingName;
    map['main_building_no'] = _mainBuildingNo;
    map['region_1depth_name'] = _region1depthName;
    map['region_2depth_name'] = _region2depthName;
    map['region_3depth_name'] = _region3depthName;
    map['road_name'] = _roadName;
    map['sub_building_no'] = _subBuildingNo;
    map['underground_yn'] = _undergroundYn;
    map['x'] = _x;
    map['y'] = _y;
    map['zone_no'] = _zoneNo;
    return map;
  }

}

/// address_name : "서울 중랑구 면목동 192-125"
/// b_code : "1126010100"
/// h_code : "1126052000"
/// main_address_no : "192"
/// mountain_yn : "N"
/// region_1depth_name : "서울"
/// region_2depth_name : "중랑구"
/// region_3depth_h_name : "면목2동"
/// region_3depth_name : "면목동"
/// sub_address_no : "125"
/// x : "127.073923291346"
/// y : "37.588016624798"

class Address {
  Address({
      String? addressName,
      String? bCode,
      String? hCode,
      String? mainAddressNo,
      String? mountainYn,
      String? region1depthName,
      String? region2depthName,
      String? region3depthHName,
      String? region3depthName,
      String? subAddressNo,
      String? x,
      String? y,}){
    _addressName = addressName;
    _bCode = bCode;
    _hCode = hCode;
    _mainAddressNo = mainAddressNo;
    _mountainYn = mountainYn;
    _region1depthName = region1depthName;
    _region2depthName = region2depthName;
    _region3depthHName = region3depthHName;
    _region3depthName = region3depthName;
    _subAddressNo = subAddressNo;
    _x = x;
    _y = y;
}

  Address.fromJson(dynamic json) {
    _addressName = json['address_name'];
    _bCode = json['b_code'];
    _hCode = json['h_code'];
    _mainAddressNo = json['main_address_no'];
    _mountainYn = json['mountain_yn'];
    _region1depthName = json['region_1depth_name'];
    _region2depthName = json['region_2depth_name'];
    _region3depthHName = json['region_3depth_h_name'];
    _region3depthName = json['region_3depth_name'];
    _subAddressNo = json['sub_address_no'];
    _x = json['x'];
    _y = json['y'];
  }
  String? _addressName;
  String? _bCode;
  String? _hCode;
  String? _mainAddressNo;
  String? _mountainYn;
  String? _region1depthName;
  String? _region2depthName;
  String? _region3depthHName;
  String? _region3depthName;
  String? _subAddressNo;
  String? _x;
  String? _y;

  String? get addressName => _addressName;
  String? get bCode => _bCode;
  String? get hCode => _hCode;
  String? get mainAddressNo => _mainAddressNo;
  String? get mountainYn => _mountainYn;
  String? get region1depthName => _region1depthName;
  String? get region2depthName => _region2depthName;
  String? get region3depthHName => _region3depthHName;
  String? get region3depthName => _region3depthName;
  String? get subAddressNo => _subAddressNo;
  String? get x => _x;
  String? get y => _y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address_name'] = _addressName;
    map['b_code'] = _bCode;
    map['h_code'] = _hCode;
    map['main_address_no'] = _mainAddressNo;
    map['mountain_yn'] = _mountainYn;
    map['region_1depth_name'] = _region1depthName;
    map['region_2depth_name'] = _region2depthName;
    map['region_3depth_h_name'] = _region3depthHName;
    map['region_3depth_name'] = _region3depthName;
    map['sub_address_no'] = _subAddressNo;
    map['x'] = _x;
    map['y'] = _y;
    return map;
  }

}
class PlaceResultModel {
  PlaceResultModel({
    List<Place>? documents,
    PlaceMeta? meta,
  }) {
    _documents = documents;
    _meta = meta;
  }

  PlaceResultModel.fromJson(dynamic json) {
    if (json['documents'] != null) {
      _documents = [];
      json['documents'].forEach((v) {
        _documents!.add(Place.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? PlaceMeta.fromJson(json['meta']) : null;
  }

  List<Place>? _documents;
  PlaceMeta? _meta;

  List<Place>? get documents => _documents;

  PlaceMeta? get meta => _meta;

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

/// is_end : false
/// pageable_count : 45
/// same_name : {"keyword":"옛","region":[],"selected_region":""}
/// total_count : 587

class PlaceMeta {
  PlaceMeta({
    bool? isEnd,
    num? pageableCount,
    RegionInfo? sameName,
    num? totalCount,
  }) {
    _isEnd = isEnd;
    _pageableCount = pageableCount;
    _sameName = sameName;
    _totalCount = totalCount;
  }

  PlaceMeta.fromJson(dynamic json) {
    _isEnd = json['is_end'];
    _pageableCount = json['pageable_count'];
    _sameName = json['same_name'] != null
        ? RegionInfo.fromJson(json['same_name'])
        : null;
    _totalCount = json['total_count'];
  }

  bool? _isEnd;
  num? _pageableCount;
  RegionInfo? _sameName;
  num? _totalCount;



  bool? get isEnd => _isEnd;
  num? get pageableCount => _pageableCount;
  RegionInfo? get sameName => _sameName;
  num? get totalCount => _totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_end'] = _isEnd;
    map['pageable_count'] = _pageableCount;
    if (_sameName != null) {
      map['same_name'] = _sameName!.toJson();
    }
    map['total_count'] = _totalCount;
    return map;
  }
}

/// keyword : "옛"
/// region : []
/// selected_region : ""

class RegionInfo {
  RegionInfo({
    String? keyword,
    List<dynamic>? region,
    String? selectedRegion,
  }) {
    _keyword = keyword;
    _region = region;
    _selectedRegion = selectedRegion;
  }

  RegionInfo.fromJson(dynamic json) {
    _keyword = json['keyword'];
    if (json['region'] != null) {
      _region = [];
      // json['region'].forEach((v) {
      //   _region!.add(String.fromJson(v));
      // });
    }
    _selectedRegion = json['selected_region'];
  }

  String? _keyword;
  List<dynamic>? _region;
  String? _selectedRegion;

  String? get keyword => _keyword;

  List<dynamic>? get region => _region;

  String? get selectedRegion => _selectedRegion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['keyword'] = _keyword;
    if (_region != null) {
      map['region'] = _region!.map((v) => v.toJson()).toList();
    }
    map['selected_region'] = _selectedRegion;
    return map;
  }
}

/// address_name : "전북특별자치도 군산시 장미동 49-38"
/// category_group_code : ""
/// category_group_name : ""
/// category_name : "여행 > 관광,명소 > 문화유적 > 유적지"
/// distance : ""
/// id : "8236329"
/// phone : "063-730-8721"
/// place_name : "옛군산세관"
/// place_url : "http://place.map.kakao.com/8236329"
/// road_address_name : "전북특별자치도 군산시 해망로 244-7"
/// x : "126.7112359403672"
/// y : "35.991075870642184"

class Place {
  Place({
    String? addressName,
    String? categoryGroupCode,
    String? categoryGroupName,
    String? categoryName,
    String? distance,
    String? id,
    String? phone,
    String? placeName,
    String? placeUrl,
    String? roadAddressName,
    String? x,
    String? y,
  }) {
    _addressName = addressName;
    _categoryGroupCode = categoryGroupCode;
    _categoryGroupName = categoryGroupName;
    _categoryName = categoryName;
    _distance = distance;
    _id = id;
    _phone = phone;
    _placeName = placeName;
    _placeUrl = placeUrl;
    _roadAddressName = roadAddressName;
    _x = x;
    _y = y;
  }

  Place.fromJson(dynamic json) {
    _addressName = json["address_name"];
    _categoryGroupCode = json["category_group_code"];
    _categoryGroupName = json["category_group_name"];
    _categoryName = json["category_name"];
    _distance = json["distance"];
    _id = json["id"];
    _phone = json["phone"];
    _placeName = json["place_name"];
    _placeUrl = json["place_url"];
    _roadAddressName = json["road_address_name"];
    _x = json["x"];
    _y = json["y"];
  }

  String? _addressName;
  String? _categoryGroupCode;
  String? _categoryGroupName;
  String? _categoryName;
  String? _distance;
  String? _id;
  String? _phone;
  String? _placeName;
  String? _placeUrl;
  String? _roadAddressName;
  String? _x;
  String? _y;

  String? get addressName => _addressName;
  String? get categoryGroupCode => _categoryGroupCode;
  String? get categoryGroupName => _categoryGroupName;
  String? get categoryName => _categoryName;
  String? get distance => _distance;
  String? get id => _id;
  String? get phone => _phone;
  String? get placeName => _placeName;
  String? get placeUrl => _placeUrl;
  String? get roadAddressName => _roadAddressName;
  String? get x => _x;
  String? get y => _y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address_name'] = _addressName;
    map['category_group_code'] = _categoryGroupCode;
    map['category_group_name'] = _categoryGroupName;
    map['category_name'] = _categoryName;
    map['distance'] = _distance;
    map['id'] = _id;
    map['phone'] = _phone;
    map['place_name'] = _placeName;
    map['place_url'] = _placeUrl;
    map['road_address_name'] = _roadAddressName;
    map['x'] = _x;
    map['y'] = _y;
    return map;
  }
}

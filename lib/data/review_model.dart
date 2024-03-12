/// review : [{"reviewSrno":44,"storeSrno":1,"userSrno":1,"reviewContent":"reviewContent","totalPageNum":5,"score":4,"signedUrls":["http.....","http......."]}]
/// totalPageNum : 2

class ReviewModel {
  ReviewModel({
      List<Review>? review,
      int? totalPageNum,}){
    _review = review;
    _totalPageNum = totalPageNum;
}

  ReviewModel.fromJson(dynamic json) {
    if (json['review'] != null) {
      _review = [];
      json['review'].forEach((v) {
        _review!.add(Review.fromJson(v));
      });
    }
    _totalPageNum = json['totalPageNum'];
  }
  List<Review>? _review;
  int? _totalPageNum;

  List<Review>? get review => _review;
  int? get totalPageNum => _totalPageNum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_review != null) {
      map['review'] = _review!.map((v) => v.toJson()).toList();
    }
    map['totalPageNum'] = _totalPageNum;
    return map;
  }

}

/// reviewSrno : 44
/// storeSrno : 1
/// userSrno : 1
/// reviewContent : "reviewContent"
/// totalPageNum : 5
/// score : 4
/// signedUrls : ["http.....","http......."]

class Review {
  Review({
    int? reviewSrno,
    int? storeSrno,
    int? userSrno,
    String? reviewContent,
    int? totalPageNum,
    int? score,
    String? storeName,
    String? regDt,
    String? nickname,
    String? userSignUrl,
    List<String>? signedUrls,
    List<String>? reviewSignedUrls,

  }){
    _reviewSrno = reviewSrno;
    _storeSrno = storeSrno;
    _userSrno = userSrno;
    _reviewContent = reviewContent;
    _totalPageNum = totalPageNum;
    _score = score;
    _nickname = nickname;
    _userSignUrl = userSignUrl;
    _signedUrls = signedUrls;
    _reviewSignedUrls = reviewSignedUrls;
}

  Review.fromJson(dynamic json) {
    _reviewSrno = json['reviewSrno'];
    _storeSrno = json['storeSrno'];
    _userSrno = json['userSrno'];
    _reviewContent = json['reviewContent'];
    _totalPageNum = json['totalPageNum'];
    _score = json['score'];
    _storeName = json['storeName'];
    _regDt = json['regDt'];
    _nickname = json['nickname'];
    _userSignUrl = json['userSignUrl'];
    _signedUrls = json['signedUrls'] != null ? json['signedUrls'].cast<String>() : [];
    _reviewSignedUrls = json['reviewSignedUrls'] != null ? json['reviewSignedUrls'].cast<String>() : [];
  }
  int? _reviewSrno;
  int? _storeSrno;
  int? _userSrno;
  String? _reviewContent;
  int? _totalPageNum;
  int? _score;
  String? _storeName;
      String? _regDt;
      String? _nickname;
      String? _userSignUrl;
  List<String>? _signedUrls;
  List<String>? _reviewSignedUrls;

  int? get reviewSrno => _reviewSrno;
  int? get storeSrno => _storeSrno;
  int? get userSrno => _userSrno;
  String? get reviewContent => _reviewContent;
  int? get totalPageNum => _totalPageNum;
  int? get score => _score;
  String? get regDt => _regDt;
  String? get storeName => _storeName;
  String? get userSignUrl => _userSignUrl;
  String? get nickname => _nickname;
  List<String>? get signedUrls => _signedUrls;
  List<String>? get reviewSignedUrls => _reviewSignedUrls;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reviewSrno'] = _reviewSrno;
    map['storeSrno'] = _storeSrno;
    map['userSrno'] = _userSrno;
    map['reviewContent'] = _reviewContent;
    map['totalPageNum'] = _totalPageNum;
    map['score'] = _score;
    map['storeName'] = _storeName;
    map['regDt'] = _regDt;
    map['nickname'] = _nickname;
    map['userSignUrl'] = _userSignUrl;
    map['signedUrls'] = _signedUrls;
    map['reviewSignedUrls'] = _reviewSignedUrls;
    return map;
  }

}
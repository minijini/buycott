/// noticeSubject : "공지제목"
/// noticeContent : "공지내용"
/// regDt : "2024-03-11-17-14"
/// regId : "admin"

class NoticeModel {
  NoticeModel({
      String? noticeSubject,
      String? noticeContent,
      String? regDt,
      String? regId,}){
    _noticeSubject = noticeSubject;
    _noticeContent = noticeContent;
    _regDt = regDt;
    _regId = regId;
}

  NoticeModel.fromJson(dynamic json) {
    _noticeSubject = json['noticeSubject'];
    _noticeContent = json['noticeContent'];
    _regDt = json['regDt'];
    _regId = json['regId'];
  }
  String? _noticeSubject;
  String? _noticeContent;
  String? _regDt;
  String? _regId;

  String? get noticeSubject => _noticeSubject;
  String? get noticeContent => _noticeContent;
  String? get regDt => _regDt;
  String? get regId => _regId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['noticeSubject'] = _noticeSubject;
    map['noticeContent'] = _noticeContent;
    map['regDt'] = _regDt;
    map['regId'] = _regId;
    return map;
  }

}
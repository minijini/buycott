

/// message : "SUCCESS"
/// code : 200
/// data : "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5Y1RlREx1TytzRFBBaXptbWVoOVhnPT06QTAwMDAwMToxIiwiZXhwIjoxNjg5MDU1MDcyfQ.CqqXlNo2zeP9zkwJR8L4ZzKMsEz5raSLrdlQFTuurVQ"

class BaseModel {
  String? message;
  int? code;
  dynamic data;
  dynamic translations;
  String? langCode;

  BaseModel({
    this.message,
    this.code,
    this.data,
    this.translations,
    this.langCode
  });

  bool isSuccess(){
    if(code == 200){
      return true;
    }else{
      return false;
    }
  }

  BaseModel.withError({
    required int statusCode,
    String? error,
    required String msg,
  })  : this.code = statusCode,
        this.message = msg;


  BaseModel.fromJson(dynamic json) {
    message = json['message'];
    code = json['code'];
    data = json['data'];
    translations = json['translations'];
    langCode = json['langCode'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['code'] = code;
    map['data'] = data;
    map['translations'] = translations;
    map['langCode'] = langCode;
    return map;
  }
}

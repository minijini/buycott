/// fileName : "sample.jpg"
/// signedUrl : "url"

class FileModel {
  FileModel({
      String? fileName,
      String? signedUrl,}){
    _fileName = fileName;
    _signedUrl = signedUrl;
}

  FileModel.fromJson(dynamic json) {
    _fileName = json['fileName'];
    _signedUrl = json['signedUrl'];
  }
  String? _fileName;
  String? _signedUrl;

  String? get fileName => _fileName;
  String? get signedUrl => _signedUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fileName'] = _fileName;
    map['signedUrl'] = _signedUrl;
    return map;
  }

}
class Validator {
  bool _isNumeric(String s) {
    for (int i = 0; i < s.length; i++) {
      if (double.tryParse(s[i]) != null) {
        return true;
      }
    }
    return false;
  }

  String? validateEmail(String s) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(s)) {
      return '이메일을 입력해주세요';
    } else {
      return null;
    }
  }



  String? validateName(String s) {
    if (_isNumeric(s)) {
      return '정확한 이름을 입력해주세요';
    }
    if (s.isEmpty) {
      return '이름을 입력해주세요';
    }
    return null;
  }

  String? validateNum(String s,String text) {
    if (s.isEmpty) {
      return text;
    }
    if (!_isNumeric(s)) {
      return '숫자만 입력해주세요';
    }

    return null;
  }

  String? validateNull(String? s , String text) {
    if (s == null) {
      return text;
    }
    if (s.isEmpty) {
      return text;
    }
    return null;
  }


  String? validatePassword(String s) {
    String pattern =r'(?=^.{8,12}$)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,12}$'; //특수문자확인

    final  regex = RegExp(pattern);

    if (s.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if(!regex.hasMatch(s)){
      return '8자리 이상 12자리 이하 , 특수문자를 포함해주세요';
    }else{
      return null;
    }
  }

}

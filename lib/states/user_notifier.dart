
import 'package:buycott/data/result_model.dart';
import 'package:buycott/data/user_model.dart';
import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/repository/user_api_repository.dart';
import '../constants/basic_text.dart';
import '../constants/response_code.dart';
import '../constants/sharedpreference_key.dart';
import '../constants/status.dart';
import '../constants/constants.dart';
import '../utils/code_dialog.dart';
import '../utils/utility.dart';
import '../widgets/dialog/custom_dialog.dart';

class UserNotifier extends ChangeNotifier{
  final TAG = "UserNotifier";
    // MemberInfo? _memberInfo;
  String? _token ;


  AuthStatus _authStatus = AuthStatus.autologin;

    UserNotifier(){

    }

    void initUser(BuildContext context) async {


        final pref = await SharedPreferences.getInstance();
        final _pref_token = pref.getString(TOKEN_KEY) ?? "";
        final _pref_auto = pref.getBool(AUTO_LOGIN) ?? false;

        // if(_pref_auto){
        //   if(_pref_token != ''  && _pref_token != null){
        //     checkToken(context);
        //
        //     _token = _pref_token;
        //
        //     profileCall();
        //
        //   }else{
        //     _token = '';
        //   }
        // }else{
        //   _token = '';
        // }

        _authStatus = AuthStatus.autologindone;

        notifyListeners();
    }


    Future logout() async{

      _authStatus = AuthStatus.signout;
      _token = null;
      _token = '';


      Utility().setSharedPreference(TOKEN_KEY, _token);
      Utility().setSharedPreference_bool(AUTO_LOGIN, false);
      Utility().removeSharedPreference(TOKEN_KEY);
      Utility().removeSharedPreference(AUTO_LOGIN);

      notifyListeners();
    }

    // void checkToken(BuildContext context) async{
    //   final result = await UserApiRepo().checkToken();
    //
    //   if (result != null) {
    //     if (result.isSuccess()) {
    //
    //     } else {
    //       _token = '';
    //       logout();
    //       _authStatus = AuthStatus.signout;
    //       CustomDialog(funcAction: dialogPop).normalDialog(context, 'login_session_expire', '확인');
    //     }
    //   }
    // }
    //


    /*
    * 로그인
    * */
    Future login(BuildContext context , String email, String pwd) async{
      final result = await UserApiRepo().login(email, pwd);

      if (result != null) {

          if (result.isSuccess(context)) {

            var dataResult = ResultModel.fromJson(result.data);

            _token = dataResult.token ?? '';
            Utility().setSharedPreference(TOKEN_KEY, _token!);

            Log.logs("token", _token!);

            _authStatus = AuthStatus.signin;

          } else {
            _token = '';
            Utility().setSharedPreference(TOKEN_KEY, _token!);
            _authStatus = AuthStatus.signout;

            // CodeDialog().result_error_code(result.statusCode,context,dialog_text: result.error);

          }
      }
      notifyListeners();
    }

/*
    * 회원가입
    * */
    Future signUp(BuildContext context , String id , String pwd, String name, String nickname,String email, String address, String birth, String gender, String signType) async{
      final result = await UserApiRepo().signUp(id,pwd,name,nickname,email,address,birth,gender,signType);

      if (result != null) {

          if (result.isSuccess(context)) {

            var dataResult = ResultModel.fromJson(result.data);

            if(dataResult.code == signupSuccess){
              _resultDialog(context, dataResult);
              return true;
            }

          }
      }
      notifyListeners();
    }



  /*
    * 가입여부체크
    * */
  Future<int?> memberCheck(BuildContext context , String userId) async{
    final result = await UserApiRepo().memberCheck(userId);

    if (result != null) {

      if (result.isSuccess(context)) {

        var dataResult = ResultModel.fromJson(result.data);
        return dataResult.code;
      }
    }

    return null;
  }

  /*
    * 닉네임중복체크
    * */
  Future<bool> nicknameCheck(BuildContext context , String nickName) async{
    final result = await UserApiRepo().nicknameCheck(nickName);

    if (result != null) {

      if (result.isSuccess(context)) {

        var dataResult = ResultModel.fromJson(result.data);

        if(dataResult.code == nicknameSuccess){ //2002 : 사용 가능한 닉네임
          _resultDialog(context, dataResult);
          return true;
        }else{//2003 : 중복된 닉네임
          _resultDialog(context, dataResult);
          return false;
        }

      }
    }

    return false;
  }

  /*
    * 유저 이미지 조회
    * */
  Future<String?> getProfileImg(BuildContext context , int userSrno) async{
    final result = await UserApiRepo().getProfileImg(userSrno);

    if (result != null) {

      if (result.isSuccess(context)) {

        var dataResult = ResultModel.fromJson(result.data);
        return dataResult.signedUrl;
      }
    }

    return null;
  }

  /*
    * 유저 프로필 조회
    * */
  Future getProfile(BuildContext context , int userSrno) async{
    final result = await UserApiRepo().getProfile(userSrno);

    if (result != null) {

      if (result.isSuccess(context)) {

        var dataResult = ResultModel.fromJson(result.data);
        userModel = UserModel.fromJson(dataResult.body);

        notifyListeners();

      }
    }
  }

 /*
    * push 알림 yn
    * */
  Future pushSetting(BuildContext context , String pushYn) async{
    final result = await UserApiRepo().pushSetting(pushYn);

    if (result != null) {

      if (result.isSuccess(context)) {

      }
    }
  }


/*
    * pushtoken 등록
    * */
  Future pushToken(BuildContext context , String pushToken) async{
    final result = await UserApiRepo().pushToken(pushToken);

    if (result != null) {

      if (result.isSuccess(context)) {

      }
    }
  }




    //
    //
    // Future<bool?> join(BuildContext context , String birthdate,String di, String email,String hp, String nicknm, String nm, String pwd ,int marital,String mbti,int region , int regiondetail, String gender, List<XFile> fileList,String fdMarketingYn, {int? height, String? hobby} )async{
    //   final result = await UserApiRepo().join(birthdate, di,email,hp,nicknm,nm,pwd,marital,mbti,region,regiondetail,gender,fileList,fdMarketingYn,height: height,hobby: hobby);
    //
    //   if (result != null) {
    //     if (result.isSuccess()) {
    //       _join = true;
    //
    //     } else {
    //       _join = false;
    //     }
    //   }
    //   notifyListeners();
    //
    //   return _join;
    // }
    //
    //
    // Future profile() async{
    //   final result = await UserApiRepo().profile();
    //
    //   if (result != null) {
    //     if (result.isSuccess()) {
    //       _memberInfo = MemberInfo.fromJson(result.data['resMemberInfo']);
    //       _profileFileList = result.data['resFileInfoList'].map<FileModel>((json) {
    //         return FileModel.fromJson(json);
    //       }).toList();
    //
    //       setMemberInfo = _memberInfo;
    //
    //     } else {
    //       _memberInfo = null;
    //       setMemberInfo = null;
    //       _profileFileList = [];
    //     }
    //   }
    //   notifyListeners();
    // }
    //

    Future userImg(BuildContext context, int userSrno, XFile file,void Function(double) onProgress ) async{
      final result = await UserApiRepo().userImg( userSrno,  file,onProgress);

      if (result != null) {
        if (result.isSuccess(context)) {

        }
      }
    }




    Future<void> _resultDialog(BuildContext context, ResultModel resultModel) => CustomDialog(funcAction: dialogPop).normalDialog(context, resultModel.msg!, '확인');

    void dialogPop(BuildContext context) async {
      Navigator.pop(context);
    }

    void dialog_LoginPop(BuildContext context) async {
      Navigator.pop(context);
      context.goNamed(loginRouteName);
    }


    String? get token => _token;
    AuthStatus get authStatus => _authStatus;
    // MemberInfo? get memberInfo => _memberInfo;


}


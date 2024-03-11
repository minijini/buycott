
import 'package:banner_carousel/banner_carousel.dart';
import 'package:buycott/data/file_model.dart';
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
  String? _profileImg;
  List<BannerModel> _bannerList2 = [];
  List<FileModel> _bannerList = [];

  LoginPlatform _loginPlatform = LoginPlatform.none;

  AuthStatus _authStatus = AuthStatus.signout;

    UserNotifier(){
      initUser();
      getBanner();

    }

    void initUser() async {


        final pref = await SharedPreferences.getInstance();
        final _pref_token = pref.getString(TOKEN_KEY) ?? "";
        final _pref_usersrno = pref.getString(USER_SRNO) ?? "";


          if(_pref_token != ''  && _pref_token != null){
            userSrno = int.parse(_pref_usersrno);
            _getUserProfile(int.parse(_pref_usersrno));
            pushToken(int.parse(_pref_usersrno), pushtoken??"");

            _authStatus = AuthStatus.signin;
          }else{
            _authStatus = AuthStatus.signout;
          }


        notifyListeners();
    }


    Future logout() async{

      _authStatus = AuthStatus.signout;

      Utility().removeSharedPreference(TOKEN_KEY);
      Utility().removeSharedPreference(USER_SRNO);

      userSrno = null;
      pushtoken = null;

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

          if (result.isSuccess(context: context)) {

            var dataResult = ResultModel.fromJson(result.data);

            _token = dataResult.token ?? '';
            Utility().setSharedPreference(TOKEN_KEY, _token!);

            _getUserProfile(dataResult.userSrno!);

            userSrno = dataResult.userSrno!;

            pushToken(dataResult.userSrno!, pushtoken??"");

            Utility().setSharedPreference(USER_SRNO, dataResult.userSrno!.toString());


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
    Future<int?> signUp(BuildContext context , String id , String pwd, String name, String nickname,String signType,void Function(double) onProgress, {String? email, String? address, String? birth, String? gender} ) async{
      final result = await UserApiRepo().signUp(id,pwd,name,nickname,signType,onProgress,email: email,address: address,birth: birth,gender: gender);

      if (result != null) {

          if (result.isSuccess(context: context)) {

            var dataResult = ResultModel.fromJson(result.data);

            return dataResult.code;

          }
      }
      notifyListeners();
    }



  /*
    * 가입여부체크
    * */
  Future<int?> memberCheck(String userId) async{
    final result = await UserApiRepo().memberCheck(userId);

    if (result != null) {

      if (result.isSuccess()) {

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

      if (result.isSuccess(context: context)) {

        var dataResult = ResultModel.fromJson(result.data);

        if(dataResult.code == nicknameSuccess){ //2002 : 사용 가능한 닉네임

          return true;
        }else{//2003 : 중복된 닉네임

          return false;
        }

      }
    }

    return false;
  }

  /*
    * 유저 이미지 조회
    * */
  Future<String?> getProfileImg(int userSrno) async{
    final result = await UserApiRepo().getProfileImg(userSrno);

    if (result != null) {

      if (result.isSuccess()) {

        var dataResult = ResultModel.fromJson(result.data);
        _profileImg = dataResult.signedUrl;

        notifyListeners();

        return dataResult.signedUrl;


      }
    }
    return null;
  }

  /*
    * 유저 프로필 조회
    * */
  Future getProfile(int userSrno) async{
    final result = await UserApiRepo().getProfile(userSrno);

    if (result != null) {

      if (result.isSuccess()) {

        var dataResult = ResultModel.fromJson(result.data);
        userModel = UserModel.fromJson(dataResult.body);

        switch(userModel!.signType){
          case "001":
            _loginPlatform = LoginPlatform.kakao;
            break;
          case "002" :
            _loginPlatform = LoginPlatform.naver;
            break;
        }

        notifyListeners();

      }else{
        _authStatus = AuthStatus.signout;
      }
    }
  }

 /*
    * push 알림 yn
    * */
  Future pushSetting( int userSrno,String pushYn) async{
    final result = await UserApiRepo().pushSetting(userSrno,pushYn);

    if (result != null) {

      if (result.isSuccess()) {

      }
    }
  }


/*
    * pushtoken 등록
    * */
  Future pushToken(int userSrno , String pushToken) async{
    final result = await UserApiRepo().pushToken(userSrno,pushToken);

    if (result != null) {

      if (result.isSuccess()) {

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
      final result = await UserApiRepo().userImg( userSrno,  file,onProgress,context: context);

      if (result != null) {
        if (result.isSuccess(context: context)) {
          var dataResult = ResultModel.fromJson(result.data);

          _profileImg = dataResult.signedUrl ?? "";

          notifyListeners();
        }
      }
    }

  Future getBanner() async{
    final result = await UserApiRepo().getBanner();

    if (result != null) {
      if (result.isSuccess()) {
        var dataResult = ResultModel.fromJson(result.data);

        List<FileModel> _result = dataResult.body.map<FileModel>((json) {
          return FileModel.fromJson(json);
        }).toList();

        _bannerList.addAll(_result);


       // _bannerList2 = _result.asMap().entries.map((entry) {
       //    int index = entry.key;
       //    FileModel file = entry.value;
       //
       //    return BannerModel(imagePath: file.signedUrl ?? "", id: index.toString(),boxFit: BoxFit.fill);
       //  }).toList();


        notifyListeners();

      }
    }

  }




  void _getUserProfile(int userSrno ) {
    getProfile(userSrno);
    getProfileImg(userSrno);
  }


  Future<void> _resultDialog(BuildContext context, ResultModel resultModel) => CustomDialog(funcAction: dialogPop).normalDialog(context, resultModel.msg!, '확인');

    void dialogPop(BuildContext context) async {
      Navigator.pop(context);
    }


    String? get token => _token;
    String? get profileImg => _profileImg;
    List<FileModel> get bannerList => _bannerList;
    AuthStatus get authStatus => _authStatus;
    LoginPlatform get  loginPlatform=> _loginPlatform;
    // MemberInfo? get memberInfo => _memberInfo;


}


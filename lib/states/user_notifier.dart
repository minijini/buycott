
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/sharedpreference_key.dart';
import '../constants/status.dart';
import '../router/constants.dart';
import '../utils/code_dialog.dart';
import '../utils/utility.dart';
import '../widgets/dialog/custom_dialog.dart';

class UserNotifier extends ChangeNotifier{

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

    void profileCall(){
      profile();
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

    void checkToken(BuildContext context) async{
      final result = await UserApiRepo().checkToken();

      if (result != null) {
        if (result.isSuccess()) {

        } else {
          _token = '';
          logout();
          _authStatus = AuthStatus.signout;
          CustomDialog(funcAction: dialogPop).normalDialog(context, 'login_session_expire', '확인');
        }
      }
    }
    //
    // Future login(BuildContext context , String email, String pwd) async{
    //   final result = await UserApiRepo().login(email, pwd);
    //
    //   if (result != null) {
    //
    //       if (result.isSuccess()) {
    //         _token = result.data ?? '';
    //         Utility().setSharedPreference(TOKEN_KEY, _token!);
    //
    //         _authStatus = AuthStatus.signin;
    //
    //         profileCall();
    //       } else {
    //         _token = '';
    //         Utility().setSharedPreference(TOKEN_KEY, _token!);
    //         _authStatus = AuthStatus.signout;
    //
    //         CodeDialog().result_error_code(result.code,context,dialog_text: data_error);
    //
    //
    //       }
    //   }
    //   notifyListeners();
    // }
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
    //
    // Future<String> uploadFile(String fileGubun, XFile file ) async{
    //   final result = await UserApiRepo().uploadFile(fileGubun, file);
    //
    //   if (result != null) {
    //     if (result.isSuccess()) {
    //       _profileimg = result.data ;
    //
    //     } else {
    //       _profileimg ='';
    //     }
    //   }
    //   notifyListeners();
    //
    //   return _profileimg;
    // }
    //
    //
    //


    void dialogPop(BuildContext context) async {
      Navigator.pop(context);
    }

    void dialog_LoginPop(BuildContext context) async {
      Navigator.pop(context);
      context.goNamed(loginRouteName);
    }


    String? get token => _token;
    // MemberInfo? get memberInfo => _memberInfo;


}


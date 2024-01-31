import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/basic_text.dart';
import '../../constants/sharedpreference_key.dart';
import '../../data/base_model.dart';
import '../api_end_points.dart';
import '../api_params.dart';
import '../api_url.dart';
import '../api_utils.dart';

class UserApiRepo {

  UserApiRepo(){
    getToken();
  }

  void getToken()async{
    final pref =  await SharedPreferences.getInstance();
    token = pref.getString(TOKEN_KEY) ?? "";
  }

  /*
  * 로그인 요청
  * */
  Future<BaseModel?> login(String id , String pwd) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.signin;

    Map<String, dynamic>? queryParameters = { PARAM_USERID: id,
      PARAM_PASSWORD: pwd,
      PARAM_EXPIRE: "30d" };

    try {
      final response = await apiUtils.put(url: url,data: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }


 /*
  * 회원가입
  * */
  Future<BaseModel?> signUp(String id , String pwd, String name, String nickname,String email, String address, String birth, String gender, String signType) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.signup;

    Map<String, dynamic>? queryParameters = {
      PARAM_USERID: id,
      PARAM_PASSWORD: pwd,
      PARAM_USERNAME: nickname,
      PARAM_NICKNAME:nickname,
      PARAM_EMAIL: email,
      PARAM_ADDRESS: address,
      PARAM_BIRTH:birth,
      PARAM_GENDER: gender,
      PARAM_SIGHTYPE: signType };

    try {
      final response = await apiUtils.post(url: url,data: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }




  /*
  * 가입여부체크
  * */
  Future<BaseModel?> memberCheck(String id) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.checkMember;

    Map<String, dynamic>? queryParameters = { PARAM_USERID: id};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }


  /*
  * 가입여부체크
  * */
  Future<BaseModel?> nicknameCheck(String nickName) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.checkNickname;

    Map<String, dynamic>? queryParameters = { PARAM_NICKNAME: nickName};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }

/*
  * 프로필 이미지 업로드
  * */
  Future<BaseModel?> userImg(String userSrno, XFile file) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.userImg;

    final image = MultipartFile.fromFileSync(file.path,filename:file.name,contentType: MediaType("image", "jpg"));


    var formData = FormData.fromMap({
      PARAM_USERSRNO: userSrno,
      PARAM_FILES:image
      });

    try {
      final response = await apiUtils.post(url: url,data : formData);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }





/*
  * 앱 버전 정보 조회
  * */
  // Future<BaseModel?> appVersion(String type) async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return BaseModel.withError(
  //         statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
  //   }
  //
  //   String url = Api.baseUrl + ApiEndPoints.appVersion;
  //
  //   Map<String, dynamic>? queryParameters = {PARAM_FK_APPCODE: appCode,PARAM_SEARCHTYPE: type};
  //
  //
  //   try {
  //     final response = await apiUtils.get(url: url,queryParameters: queryParameters);
  //
  //     if (response != null) {
  //
  //       return BaseModel.fromJson(response.data);
  //     }
  //
  //     return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
  //   } catch (e) {
  //     return BaseModel.withError(
  //         statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
  //   }
  // }


/*
  * file 업로드 gubun(P: 프로필, B: 게시글)
  * */
  // Future<BaseModel?> uploadFile(String fileGubun, XFile file ) async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return BaseModel.withError(
  //         statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
  //   }
  //
  //   String url = Api.baseUrl + ApiEndPoints.upload_file;
  //
  //   final image = MultipartFile.fromFileSync(file.path,filename:file.name,contentType: MediaType("image", "jpg"));
  //
  //   var formData = FormData.fromMap({
  //     PARAM_FILE_GUBUN: fileGubun,
  //     PARAM_FILE : image,
  //   });
  //
  //   try {
  //
  //     final response = await apiUtils.post(url: url,data : formData,options: Options(
  //         headers: {
  //           "Access_Token" : token
  //         }
  //     ));
  //
  //     if (response != null) {
  //
  //       return BaseModel.fromJson(response.data);
  //     }
  //
  //     return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
  //   } catch (e) {
  //     return BaseModel.withError(
  //         statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
  //   }
  // }

}

import 'dart:convert';

import 'package:buycott/utils/log_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  * 앱버전체크
  * */
  Future<BaseModel?> appversion(String os,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.appversion;

    Map<String, dynamic>? queryParameters = { PARAM_OS: os};

    try {
      final response = await apiUtils.get(url: url,queryParameters: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
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
  Future<BaseModel?> signUp(String id , String pwd, String name, String nickname, String signType,void Function(double) onProgress,
      {String? email, String? address, String? birth, String? gender}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.signup;

    Map<String, dynamic>? queryParameters = {
      PARAM_USERID: id,
      PARAM_PASSWORD: pwd,
      PARAM_USERNAME: name,
      PARAM_NICKNAME:nickname,
      PARAM_EMAIL: email,
      PARAM_ADDRESS: address,
      PARAM_BIRTH:birth,
      PARAM_GENDER: gender,
      PARAM_SIGNTYPE: signType };

    try {
      final response = await apiUtils.postWithProgress(url: url,data: queryParameters,onSendProgress: (int sent, int total) {
      final progress = sent / total;
      onProgress(progress);
      });

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
  * 닉네임 체크
  * */
  Future<BaseModel?> nicknameCheck(String nickName,{BuildContext? context}) async {
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
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }

/*
  * 프로필 이미지 업로드
  * */
  Future<BaseModel?> userImg(int userSrno, XFile file,void Function(double) onProgress,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.userImg;

    final image = MultipartFile.fromFileSync(file.path,filename:file.name,contentType: MediaType("image", "jpeg"));

    var formData = FormData.fromMap({
      PARAM_USERSRNO: userSrno,
      PARAM_FILES:image
      });

    try {
      final response = await apiUtils.postWithProgress(url: url,data : formData,onSendProgress: (int sent, int total) {
        final progress = sent / total;
        Log.logs("userimg",'progress: $progress ($sent/$total)');
        onProgress(progress);
      });

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }

  /*
  * 유저 프로필 사진 조회
  * */
  Future<BaseModel?> getProfileImg(int userSrno) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.userImg;

    Map<String, dynamic>? queryParameters = { PARAM_USERSRNO: userSrno};

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

  /* 유저 프로필 조회
  * */
  Future<BaseModel?> getProfile(int userSrno) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.userProfile;

    Map<String, dynamic>? queryParameters = { PARAM_USERSRNO: userSrno};

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

  /* 닉네임 수정
  * */
  Future<BaseModel?> modifyNickname(int userSrno,String nickname,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.userProfile;

    debugPrint('userSrno :: $userSrno , nickname :: $nickname');

    Map<String, dynamic>? queryParameters = { PARAM_USERSRNO: userSrno,PARAM_NICKNAME:nickname};

    try {
      final response = await apiUtils.put(url: url,data: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
    }
  }




  /*
  * pushtoken 등록
  * */
  Future<BaseModel?> pushToken(int userSrno,String pushToken) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.pushToken;

    Map<String, dynamic>? queryParameters = {
      PARAM_USERSRNO: userSrno,
      PARAM_PUSHTOKEN: pushToken,
     };

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
  * push 알림 Yn
  * */
  Future<BaseModel?> pushSetting(int userSrno,String pushYn) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.pushSetting;

    Map<String, dynamic>? queryParameters = {
      PARAM_USERSRNO: userSrno,
      PARAM_PUSHYN: pushYn,
    };

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


  /* 배너 조회
  * */
  Future<BaseModel?> getBanner() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.banner;

    try {
      final response = await apiUtils.get(url: url);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }

  /* 공지사항 조회
  * */
  Future<BaseModel?> getNotice() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.notice;

    try {
      final response = await apiUtils.get(url: url);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }

  /* 관심가게조회
  * */
  Future<BaseModel?> favoriteList(int userSrno) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.watchlist;

    Map<String, dynamic>? queryParameters = { PARAM_USERSRNO: userSrno};

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



  /* 관심가게 등록
  * */
  Future<BaseModel?> favoriteAdd(String storeSrno,int userSrno) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.watchlist;


    Map<String, dynamic>? queryParameters = { PARAM_STORESRNO : storeSrno,
      PARAM_USERSRNO: userSrno};

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

  /* 관심가게삭제
  * */
  Future<BaseModel?> favoriteDelete(String storeSrno,int userSrno) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.watchlist;


    Map<String, dynamic>? queryParameters = { PARAM_STORESRNO : storeSrno,
      PARAM_USERSRNO: userSrno};

    try {
      final response = await apiUtils.delete(url: url,data: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e));
    }
  }


  /* 회원탈퇴
  * */
  Future<BaseModel?> memberDrop(int userSrno,{BuildContext? context}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return BaseModel.withError(
          statusCode: CODE_NO_INTERNET, msg: apiUtils.getNetworkError());
    }

    String url = Api.baseUrl + ApiEndPoints.withdrawal;


    Map<String, dynamic>? queryParameters = { PARAM_USERSRNO: userSrno};

    try {
      final response = await apiUtils.put(url: url,data: queryParameters);

      if (response != null) {

        return BaseModel.fromJson(response.data);
      }

      return BaseModel.withError(statusCode: CODE_RESPONSE_NULL, msg: "");
    } catch (e) {
      return BaseModel.withError(
          statusCode: CODE_ERROR, msg: apiUtils.handleError(e,context: context));
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

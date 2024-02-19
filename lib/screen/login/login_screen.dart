import 'dart:convert';
import 'dart:io';
import 'package:buycott/constants/constants.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:device_screen_size/device_screen_size.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';


import '../../constants/screen_size.dart';
import '../../constants/status.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TAG = "LoginScreen";

  LoginPlatform _loginPlatform = LoginPlatform.none;
  bool _isKaKaoTalkInstalled = true;

  @override
  void initState() {
    super.initState();
    _initKaKaoTalkInstalled();
  }

   _initKaKaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKaKaoTalkInstalled = installed;
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('로그인',style: Theme.of(context).textTheme.titleLarge,),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _snsLoginButton("kakao_login",signInWithKakao),
            _snsLoginButton("naver_login",signInWithNaver),

          ],
        ),
      ),
    );
  }

  GestureDetector _snsLoginButton(String path, VoidCallback onTap) {
    return GestureDetector(
            onTap: onTap,
            child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Image.asset("assets/login/$path.png")),
          );
  }

  void signInWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        Log.logs(TAG,'카카오톡으로 로그인 성공');
      } catch (error) {
        Log.logs(TAG,'카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          Log.logs(TAG,'카카오계정으로 로그인 성공');

          _get_kakao_user_info();

        } catch (error) {
          Log.logs(TAG,'카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        Log.logs(TAG,'카카오계정으로 로그인 성공');
        _get_kakao_user_info();
      } catch (error) {
        Log.logs(TAG,'카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void _get_kakao_user_info() async {
    try {
      User user = await UserApi.instance.me();
      Log.logs(TAG,'사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');
    } catch (error) {
      Log.logs(TAG,'사용자 정보 요청 실패 $error');
    }
  }

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      Log.logs(TAG,'accessToken = ${result.accessToken}');
      Log.logs(TAG,'id = ${result.account.id}');
      Log.logs(TAG,'email = ${result.account.email}');
      Log.logs(TAG,'birthday = ${result.account.birthday}');
      Log.logs(TAG,'gender = ${result.account.gender}');

      setState(() {
        _loginPlatform = LoginPlatform.naver;
      });
    }
  }

  void loginStatus(String userId){
    context.goNamed(signUpRouteName, pathParameters: {'userId': userId});
  }



}

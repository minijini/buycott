import 'dart:convert';
import 'dart:io';
import 'package:buycott/constants/constants.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:device_screen_size/device_screen_size.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';


import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../constants/status.dart';
import '../../states/user_notifier.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('로그인',style: Theme.of(context).textTheme.titleLarge,),
          centerTitle: false,
          titleSpacing: -10,
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,))
      ),
      body: Container(
        padding: EdgeInsets.only(top: sized_100),
        child: Column(
          children: [
            Image.asset('assets/icon/icon_donzzule.png',width: 148,height: 96,),
            heightSizeBox(sized_30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _snsLoginButton("naver",signInWithNaver,BasicColor.naver_green),
                widthSizeBox(sized_30),
                _snsLoginButton("kakao",signInWithKakao,BasicColor.kakao_yellow),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _snsLoginButton(String path, VoidCallback onTap,Color color) {
    return GestureDetector(
            onTap: onTap,
            child: Container(
              width: sized_50,
              height: sized_50,
              child:  Image.asset("assets/login/icon_${path}_login_simple.png",width: 50,
                height: 50,fit: BoxFit.fill,),
            ),
          );
  }

  void signInWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        Log.logs(TAG,'카카오톡으로 로그인 성공');

        _get_kakao_user_info();
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

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      login("${user.id}", "001");
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

      login(result.account.id, "002");
    }
  }

  void login(String userId,String signType){
    Provider.of<UserNotifier>(context,listen: false).memberCheck(userId).then((value){
      if(value == 2000){ //가입페이지 이동
        context.goNamed(signUpRouteName, pathParameters: {'userId': userId,'signType':signType});
      }else{ //기존회원 로그인
        Provider.of<UserNotifier>(context,listen: false).login(context, userId, "$userId$signType").then((value) => Navigator.pop(context,"reset"));
      }
    });

  }



}

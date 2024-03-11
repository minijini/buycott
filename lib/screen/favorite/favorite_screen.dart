import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: 18,
              title: Text(
                "즐겨찾기",
                style: Theme.of(context).textTheme.titleLarge,
              ),
          ),
        backgroundColor: Colors.white,
        body: userSrno == null ? _loginPage(context) : _EmptyPage(context)
      ),
    );
  }

  Container _loginPage(BuildContext context) {
    return Container(
        width: size!.width,
        height: size!.height,
        padding: EdgeInsets.only(top: sized_150),
        child:  RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "로그인이 필요한 페이지 입니다.\n\n로그인 하시려면 ",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4),
            children: <TextSpan>[
              TextSpan(
                  text: "여기", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4,decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.goNamed(loginRouteName);
                  },),
              TextSpan(
                  text: "를 눌러주세요.", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4)),
            ],
          ),
        ),
      );
  }

  Container _EmptyPage(BuildContext context) {
    return Container(
      width: size!.width,
      height: size!.height,
      padding: EdgeInsets.only(top: sized_150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("즐겨찾기한 가게가 없습니다.",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4)),
          heightSizeBox(sized_5),
          Text("목록을 추가해 주세요.",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4)),
        ],
      ),
    );
  }
}

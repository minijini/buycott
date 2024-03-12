import 'package:auto_size_text/auto_size_text.dart';
import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/status.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/style/container.dart';

class MyProfileScreen extends StatefulWidget {
  final UserNotifier userNotifier;

  const MyProfileScreen({super.key, required this.userNotifier});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final GoRouter goRouter;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding_side),
          child: Text(
            "MY",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // heightSizeBox(widget.userNotifier.authStatus == AuthStatus.signin ? sized_14 : sized_50),

            widget.userNotifier.authStatus == AuthStatus.signin ?  Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding_side),
                  child: _myProfile(context),
                ),
                heightSizeBox(sized_30),
                _menu(context, "내가 제안한 가게", true, () {
                  context.goNamed(
                    myStoreRegisterRouteName,
                  );
                }),
                _menu(context, "내가 쓴 리뷰", true, () {
                  context.goNamed(myReviewRouteName);
                }),

                _menu(context, "가게 제안", true, () {
                  context.goNamed(storeAddRouteName);
                }),
              ],
            ) :  _menu(context, "로그인해주세요", true, () {
              if(widget.userNotifier.authStatus == AuthStatus.signout){
                context.goNamed(loginRouteName);
              }
            }),
            _menu(context, "공지사항", false, () {
              context.goNamed(noticeRouteName);
            }),
            _menu(context, "이용약관", false, () {
              context.goNamed(termsRouteName, pathParameters: {'title': '이용약관'});
            }),
            _menu(context, "개인정보취급방침", false, () {
              context
                  .goNamed(termsRouteName, pathParameters: {'title': '개인정보취급방침'});
            }),
            heightSizeBox(sized_60),
            Visibility(
              visible: widget.userNotifier.authStatus == AuthStatus.signin,
              child: GestureDetector(
                  onTap: (){
                    signOut(widget.userNotifier.loginPlatform);
                  },
                  child: Text("로그아웃",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: BasicColor.lightgrey4,decoration: TextDecoration.underline),)),
            )
          ],
        ),
      ),
    );
  }

  Column _menu(
      BuildContext context, String title, bool visible, void Function() onTap) {
    return Column(
      children: [
        ListTile(
          dense: true,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: padding_side,
          ),
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: sized_18)),
          onTap: onTap,
          trailing: Visibility(
              visible: visible,
              child: Icon(
                Icons.chevron_right,
                size: sized_25,
                color: Colors.black,
              )),
        ),
        divider()
      ],
    );
  }

  Widget _myProfile(BuildContext context) {
    return Column(
      children: [
        heightSizeBox(sized_10),
        Row(
          children: [
            Row(
              children: [
                CircleImage(
                  img: widget.userNotifier.profileImg,
                  size: sized_60,
                ),
                widthSizeBox(sized_10),
                Text(
                  userModel?.nickname ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
            // Expanded(
            //     child: Align(
            //   alignment: Alignment.centerRight,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       signOut(widget.userNotifier.loginPlatform);
            //     },
            //     style: ElevatedButton.styleFrom(
            //       shadowColor: Colors.transparent,
            //         backgroundColor: BasicColor.lightgrey,
            //         shape: RoundedRectangleBorder(
            //             //모서리를 둥글게
            //             borderRadius: BorderRadius.circular(20)),
            //       ),
            //       child: SizedBox(
            //         width: sized_30,
            //         height: sized_17,
            //         child: Center(
            //             child: AutoSizeText('수정',
            //                 style: Theme.of(context)
            //                   .textTheme
            //                   .displaySmall!
            //                   )),
            //     ),
            //   ),
            // )),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.goNamed(myProfileEditRouteName);
                  },
                  child: Container(
                    width: sized_40,
                    height: sized_26,
                    decoration: grayDecor(sized_15),
                    child: Center(
                      child: AutoSizeText('수정',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                      ),
                    ),

                  ),
                ),
              ),
            )

          ],
        ),
      ],
    );
  }



  void signOut(LoginPlatform _loginPlatform) async {

    Provider.of<UserNotifier>(context,listen: false).logout();

    switch (_loginPlatform) {
      case LoginPlatform.facebook:
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }
}

import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/data/store_model.dart';
import 'package:buycott/screen/login/login_screen.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/empty_screen.dart';
import 'package:buycott/widgets/list/store_list_tile.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../states/user_notifier.dart';
import '../../widgets/NoGlowScrollBehavior.dart';
import '../../widgets/circle_progressbar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool getFavoreList = false;

  @override
  void initState() {
    super.initState();

    debugPrint("userSrno :: $userSrno");

    if(userSrno != null) {
      getFavorite();
    }
  }

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
        body: userSrno == null ? _loginPage(context) : Container(
          width: device_width!,
          height: size!.height,
          child: _favoriteList(),
        )
      ),
    );
  }

  Widget _favoriteList() {
    return  ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Consumer<UserNotifier>(
          builder: (context, notifier, widget) {
            return notifier.favoriteList.isNotEmpty ? ListView.separated(
                itemBuilder: (context, index) {
                  StoreModel store = notifier.favoriteList[index];

                  return GestureDetector(
                      onTap: (){
                        context.goNamed(storeDetailRouteName,pathParameters: {
                          'storeSrno' : store.storeSrno.toString()
                        });
                      },
                      child: StoreListTile(placeName: store.storeName ?? "", addressName: store.storeAddress ?? "", likeYn: true,storeSrno: store.storeSrno.toString(),searchYn: false,));
                },
                separatorBuilder: (context, index) {
                  return divider();
                },
                itemCount: notifier.favoriteList.length) : getFavoreList ? _EmptyPage(context) : CustomCircularProgress();
          }
      ),
    );
  }

  Container _loginPage(BuildContext context) {
    return Container(
        width: device_width!,
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
                  ..onTap = () async {
                    context.goNamed(loginRouteName);

                    // var result = await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LoginScreen(),
                    //   ),
                    // );
                    //
                    // if(result == "reset"){
                    //   if(userSrno != null) {
                    //     getFavorite();
                    //   }
                    // }

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
      width: device_width!,
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

  void getFavorite(){
    Provider.of<UserNotifier>(context,listen: false).getFavoriteList(userSrno!).then((value){
      setState(() {
        getFavoreList = true;
      });
    });
  }

}

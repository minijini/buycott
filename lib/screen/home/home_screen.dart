

import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../firebase/fcmprovider.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/utility.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/style/container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomSelectedIndex = 0;

  late UserNotifier _userNotifier;

  final List<Widget> _screens = <Widget>[

    // Consumer<ReNotifier>(
    //   builder: (context,notifier,child){
    //     return RecommendScreen(reNotifier: notifier,);
    //   },
    // ),

  ];

  DateTime? currentBackPressTime; //app종료

  @override
  void initState() {
    getDeviceId();

    _userNotifier = UserNotifier();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      FCMProvider.setContext(context);
    });

    Provider.of<UserNotifier>(context,listen: false).login(context,"seongijin","1234");


    super.initState();
  }

  void getDeviceId() async {

    String deviceunique = await FlutterUdid.udid;

    //pushtoken 등록
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(),
    );

    // return WillPopScope(
    //   onWillPop: onWillPop,
    //   child: Scaffold(
    //     body: _screens.elementAt(_bottomSelectedIndex),
    //     appBar: AppBar(
    //         elevation: 0,
    //         actions: [
    //           Consumer<UserNotifier>(
    //             builder: (context, userNotifier, child) {
    //               return Row(
    //                 children: [
    //                   InkWell(
    //                     onTap: () {
    //                       // context.goNamed(flowerShopRouteName);
    //                     },
    //                     child: Container(
    //                       margin: EdgeInsets.symmetric(
    //                           vertical: sized_13, horizontal: sized_10),
    //                       decoration: appBarDecor(Colors.white),
    //                       width: sized_95,
    //
    //                       child: Row(
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.only(
    //                                 left: sized_5,
    //                                 top: sized_4,
    //                                 bottom: sized_4,
    //                                 right: sized_5),
    //                             child: Image.asset(
    //                               'assets/imgs/icon_rose.png',
    //                               width: sized_17,
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Center(
    //                               child: Text(
    //                                 Utility().comma('00000'),
    //                                 style: Theme.of(context)
    //                                     .textTheme
    //                                     .bodyMedium!
    //                                     .copyWith(color: BasicColor.primary),
    //                               ),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(
    //                                 left: sized_2, right: sized_5),
    //                             child: CircleImage(
    //                               img: userNotifier.profileFileList.isNotEmpty
    //                                   ? '$filePath$fileNm'
    //                                   : '',
    //                               size: sized_20,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             },
    //           )
    //         ],
    //         centerTitle: false,
    //         title: Image.asset(
    //           'assets/imgs/icon_title.png',
    //           width: sized_40,
    //           height: sized_30,
    //         )),
    //     bottomNavigationBar: BottomNavigationBar(
    //       currentIndex: _bottomSelectedIndex,
    //       type: BottomNavigationBarType.fixed,
    //       //icon&label 보여주는 타입 , fixed : 애니메이션 없음
    //       items: [
    //         BottomNavigationBarItem(
    //             icon: Container(
    //               padding: const EdgeInsets.symmetric(vertical: sized_2),
    //               child: ImageIcon(AssetImage(_bottomSelectedIndex == 0
    //                   ? 'assets/imgs/icon_recomm_on.png'
    //                   : 'assets/imgs/icon_recomm_off.png')),
    //             ),
    //             label: '추천'),
    //         //선택 될 때 채워진 이미지로 변경
    //         BottomNavigationBarItem(
    //             icon: Container(
    //               padding: const EdgeInsets.symmetric(vertical: sized_2),
    //               child: ImageIcon(AssetImage(_bottomSelectedIndex == 1
    //                   ? 'assets/imgs/icon_request_on.png'
    //                   : 'assets/imgs/icon_request_off.png')),
    //             ),
    //             backgroundColor: Colors.transparent,
    //             label: '요청'),
    //         BottomNavigationBarItem(
    //             icon: Stack(
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.symmetric(vertical: sized_2),
    //                   child: ImageIcon(AssetImage(_bottomSelectedIndex == 2
    //                       ? 'assets/imgs/icon_talk_on.png'
    //                       : 'assets/imgs/icon_talk_off.png')),
    //                 ),
    //                 // Align(
    //                 //   alignment: Alignment.topRight,
    //                 //   child: Container(
    //                 //     width: sized_15,
    //                 //     height: sized_15,
    //                 //     decoration: talkAlarmDecor(),
    //                 //     child: Text(
    //                 //       '1',
    //                 //       style: Theme.of(context)
    //                 //           .textTheme
    //                 //           .bodySmall!
    //                 //           .copyWith(
    //                 //         color: Colors.white,
    //                 //       ),
    //                 //       textAlign: TextAlign.center,
    //                 //     ),
    //                 //   ),
    //                 // ),
    //               ],
    //             ),
    //             label: '대화'),
    //         BottomNavigationBarItem(
    //             icon: Container(
    //               padding: const EdgeInsets.symmetric(vertical: sized_2),
    //               child: ImageIcon(AssetImage(_bottomSelectedIndex == 3
    //                   ? 'assets/imgs/icon_set_on.png'
    //                   : 'assets/imgs/icon_set_off.png')),
    //             ),
    //             label: '설정'),
    //       ],
    //       onTap: (index) {
    //         setState(() {
    //           _bottomSelectedIndex = index;
    //         });
    //
    //       },
    //     ),
    //   ),
    // );
  }


  // void recommMore(){
  //   Provider.of<ReNotifier>(context,listen: false).recommendMore(context);
  // }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

      Utility.customSnackBar(context, msg);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

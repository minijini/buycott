import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/screen/home/home_screen.dart';
import 'package:buycott/screen/login/login_screen.dart';
import 'package:buycott/screen/map/map_screen.dart';
import 'package:buycott/screen/place/shop_list_screen.dart';
import 'package:buycott/states/place_notifier.dart';
import 'package:buycott/states/store_notifier.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:buycott/widgets/list/place_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../data/place_result_model.dart';
import '../../firebase/fcmprovider.dart';
import '../../states/user_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/utility.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/style/container.dart';
import '../../widgets/style/divider.dart';
import '../bottomScreen.dart';
import '../login/sign_up_screen.dart';
import '../map/bottom_sheet_screen.dart';
import '../bottomScreen3.dart';
import '../myprofile/myprofile_screen.dart';
import '../store/store_add_screen.dart';
import '../store/store_detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  int _bottomSelectedIndex = 0;

  late UserNotifier _userNotifier;



  final List<Widget> _screens = <Widget>[
    // Consumer<PlaceNotifier>(
    //   builder: (context,notifier,child){
    //     return ShopListScreen();
    //   },
    // ),
    HomeScreen(),
    Consumer<StoreNotifier>(
      builder: (context,notifier,child){
        return MapScreen(storeNotifier: notifier,);
      },
    ),
    StoreAddScreen(),
    Consumer<UserNotifier>(
      builder: (context,notifier,child){
        return MyProfileScreen(userNotifier: notifier,);
      },
    ),
  ];

  DateTime? currentBackPressTime; //app종료

  @override
  void initState() {
    getDeviceId();

    _userNotifier = UserNotifier();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FCMProvider.setContext(context);
    });




    // Provider.of<UserNotifier>(context,listen: false).login(context,"admin","1234");
    // Provider.of<UserNotifier>(context,listen: false).nicknameCheck(context,"admin");

    super.initState();
  }


  void getDeviceId() async {
    String deviceunique = await FlutterUdid.udid;

    //pushtoken 등록
  }


  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        onBackPop();
      },
      child: Scaffold(
        body: SafeArea(child: _screens.elementAt(_bottomSelectedIndex)),
        // appBar: AppBar(
        //     elevation: 0,
        //     actions: [
        //       Consumer<UserNotifier>(
        //         builder: (context, userNotifier, child) {
        //           return Row(
        //             children: [
        //
        //             ],
        //           );
        //         },
        //       )
        //     ],
        //     centerTitle: false,
        //     // title: Image.asset(
        //     //   'assets/imgs/icon_title.png',
        //     //   width: sized_40,
        //     //   height: sized_30,
        //     // )
        // ),
       bottomNavigationBar: Container(
           decoration: BoxDecoration(
             boxShadow: [
               BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 20,),
             ],
           ),
           child: ClipRRect(
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(sized_13),
               topRight: Radius.circular(sized_13),
             ),
             child:  BottomNavigationBar(
               backgroundColor: BasicColor.primary,
             currentIndex: _bottomSelectedIndex,
             type: BottomNavigationBarType.fixed,
               showSelectedLabels: false,
               showUnselectedLabels: false,
             //icon&label 보여주는 타입 , fixed : 애니메이션 없음
             items: [
               BottomNavigationBarItem(
                   icon: Container(
                     padding: const EdgeInsets.symmetric(vertical: sized_2),
                     child: ImageIcon(AssetImage(_bottomSelectedIndex == 0
                         ? 'assets/icon/icon_home_off.png'
                         : 'assets/icon/icon_home_off.png')),
                   ),
                   label: '추천'),
               //선택 될 때 채워진 이미지로 변경
               BottomNavigationBarItem(
                   icon: Container(
                     padding: const EdgeInsets.symmetric(vertical: sized_2),
                     child: ImageIcon(AssetImage(_bottomSelectedIndex == 1
                         ? 'assets/icon/icon_location_off.png'
                         : 'assets/icon/icon_location_off.png')),
                   ),
                   backgroundColor: Colors.transparent,
                   label: '요청'),
               BottomNavigationBarItem(
                   icon: Stack(
                     children: [
                       Container(
                         padding: const EdgeInsets.symmetric(vertical: sized_2),
                         child: ImageIcon(AssetImage(_bottomSelectedIndex == 2
                             ? 'assets/icon/icon_favorite_off.png'
                             : 'assets/icon/icon_favorite_off.png')),
                       ),
                     ],
                   ),
                   label: '대화'),
               BottomNavigationBarItem(
                   icon: Container(
                     padding: const EdgeInsets.symmetric(vertical: sized_2),

                     child: ImageIcon(AssetImage(_bottomSelectedIndex == 3
                         ? 'assets/icon/icon_my_off.png'
                         : 'assets/icon/icon_my_off.png')),
                   ),

                   label: '설정'),
             ],
             onTap: (index) {
               setState(() {
                 _bottomSelectedIndex = index;
               });

             },
           ),
           )
       ),
      ),
    );
  }


  void onBackPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

      Utility.customSnackBar(context, msg,backgroundColor: Colors.white);

    }else{
      SystemNavigator.pop();
    }

  }


}

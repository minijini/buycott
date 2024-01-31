import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/states/place_notifier.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:buycott/widgets/place_list_tile.dart';
import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomSelectedIndex = 0;

  late UserNotifier _userNotifier;

  FocusNode _focusNode = FocusNode();

  List<Place> placeList = [];
  int page = 1;
  String searchKeyWord = "";
  bool isEndYn = false;
  final ScrollController _scrollController = ScrollController();

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

    _scrollController.addListener(() {
      scrollListener();
    });


    // Provider.of<UserNotifier>(context,listen: false).login(context,"admin","1234");
    // Provider.of<UserNotifier>(context,listen: false).nicknameCheck(context,"admin");

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void getPlaceList(String text,int pageIndex) {
    Provider.of<PlaceNotifier>(context, listen: false)
        .placeSearch(context, text,pageIndex)
        .then((value) {
      setState(() {
        if(value != null){
          for (var data in value) {
            placeList.add(data);
          }

          setState(() {
            page ++; //페이지증가
            isEndYn = context.read<PlaceNotifier>().endYn;
          });
        }
      });
    });
  }

  void getDeviceId() async {
    String deviceunique = await FlutterUdid.udid;

    //pushtoken 등록
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            _placeSearchBar(),
            _placeList()
          ],
        ),
      ),
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

  TextField _placeSearchBar() {
    return TextField(
            focusNode: _focusNode,
            autofocus: true,
            keyboardType: TextInputType.text,
            onChanged: (text) {

              setState(() {
                searchKeyWord = text;

                if(placeList != null) {
                  page = 1;
                  placeList!.clear();
                }
              });

              getPlaceList(searchKeyWord,page);

            },
            cursorColor: Colors.blueGrey,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow,
                contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                hintText: "장소를 입력해주세요",
                border: InputBorder.none,

                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 13),
                    child: Icon(Icons.search,color: Colors.blueGrey,))),
          );
  }

  Widget _placeList() {
    return (placeList.isNotEmpty)
        ? Expanded(
          child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                Place placeModel = placeList[index];

                return GestureDetector(
                    onTap: () {
                      Log.logs(
                          TAG, "list tile click :: ${placeModel.placeName!}");
                    },
                    child: PlaceListTile(
                        placeName: placeModel.placeName!,
                        addressName: placeModel.roadAddressName!));
              },
              separatorBuilder: (context, index) {
                return list_divider();
              },
              itemCount: placeList.length),
        )
        : Container(
            color: Colors.amber,
          );
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

  scrollListener() async {
    if (_scrollController.offset  == _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {

      if(!isEndYn) {
        getPlaceList(searchKeyWord, page);
      }
    }
  }
}

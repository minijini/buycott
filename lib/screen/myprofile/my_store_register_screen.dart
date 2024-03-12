import 'package:buycott/data/store_model.dart';
import 'package:buycott/states/store_notifier.dart';
import 'package:buycott/widgets/circle_progressbar.dart';
import 'package:buycott/widgets/list/my_shop_register_list_tile.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/basic_text.dart';
import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/NoGlowScrollBehavior.dart';
import '../../widgets/list_empty_screen.dart';

class MyStoreRegisterScreen extends StatefulWidget {
  const MyStoreRegisterScreen({super.key});

  @override
  State<MyStoreRegisterScreen> createState() => _MyStoreRegisterScreenState();
}

class _MyStoreRegisterScreenState extends State<MyStoreRegisterScreen> {
  bool getMyStoreList = false;

  @override
  void initState() {
    super.initState();

    getMyStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '내가 제안한 가게',
          style: Theme.of(context).textTheme.titleLarge,
        ),
          centerTitle: false,
          titleSpacing: -10,
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,))
      ),
      body:Container(
        width: size!.width,
        height: size!.height,
        child: _myStoreList(),
      ),
    );
  }

  Widget _myStoreList() {
    return  ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Consumer<StoreNotifier>(
          builder: (context, notifier, widget) {
            return notifier.myStoreList.isNotEmpty ? ListView.separated(
                itemBuilder: (context, index) {
                  StoreModel notice = notifier.myStoreList[index];

                  return MyShopRegisterListTile(storeModel: notice,);
                },
                separatorBuilder: (context, index) {
                  return divider();
                },
                itemCount: notifier.myStoreList.length) : getMyStoreList ? ListEmptyScreen(title: '내가 제안한 가게가 없습니다.',) : CustomCircularProgress();
          }
      ),
    );
  }


  void getMyStores(){
    Provider.of<StoreNotifier>(context,listen: false).myStores(context, userSrno!).then((value){
      setState(() {
        getMyStoreList = true;
      });
    });
  }
}



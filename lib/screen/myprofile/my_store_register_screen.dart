import 'package:buycott/widgets/list/my_shop_register_list_tile.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';

class MyStoreRegisterScreen extends StatefulWidget {
  const MyStoreRegisterScreen({super.key});

  @override
  State<MyStoreRegisterScreen> createState() => _MyStoreRegisterScreenState();
}

class _MyStoreRegisterScreenState extends State<MyStoreRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: sized_18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: sized_18),
              //   child: Text(
              //     '내가 등록한 가게',
              //     style: Theme.of(context).textTheme.titleLarge,
              //   ),
              // ),
              // heightSizeBox(sized_26),
              MyShopRegisterListTile(),

            ],
          ),
        ),
      ),
    );
  }
}

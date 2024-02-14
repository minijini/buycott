import 'package:buycott/widgets/list/my_shop_register_list_tile.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';

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
          '내가 등록한 가게',
          style: Theme.of(context).textTheme.titleLarge,
        ),
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

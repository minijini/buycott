import 'package:buycott/widgets/list/my_review_list_tile.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내가 쓴 리뷰',
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

              MyReviewListTile(),

            ],
          ),
        ),
      ),
    );
  }
}

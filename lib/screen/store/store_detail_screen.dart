import 'package:banner_carousel/banner_carousel.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../widgets/list/review_list_tile.dart';
import '../../widgets/start_widget.dart';
import '../../widgets/style/container.dart';
import '../../widgets/style/divider.dart';
import '../home/home_screen.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({super.key});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          '가게명',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            heightSizeBox(sized_18),
            _storeInfo(context),
            heightSizeBox(sized_30),
            customDivider(BasicColor.linegrey2, sized_8, sized_8),
            heightSizeBox(sized_30),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sized_18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '리뷰',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: sized_20,
                      )
                    ],
                  ),
                ),
                heightSizeBox(sized_30),
              ],
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {}, child: ReviewListTile());
                  },
                  separatorBuilder: (context, index) {
                    return divider();
                  },
                  itemCount: 10),
            )
          ],
        ),
      ),
    );
  }

  Padding _storeInfo(BuildContext context) {
    Widget starIcons = buildStarRating(3, sized_16);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sized_18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '가게명',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.close),
                        color: BasicColor.primary2,
                        iconSize: sized_30,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )))
            ],
          ),
          heightSizeBox(sized_24),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: '영업시간 ',
              style: Theme.of(context).textTheme.displayMedium,
              children: <TextSpan>[
                TextSpan(
                    text: '11:00~12:00', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          heightSizeBox(sized_10),
          Row(
            children: [
              Text('댓글 97', style: Theme.of(context).textTheme.displayMedium),
              widthSizeBox(sized_6),
              starIcons
            ],
          ),
          heightSizeBox(sized_10),
          Text('주소', style: Theme.of(context).textTheme.bodyMedium),
          heightSizeBox(sized_10),
          Text('설명', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

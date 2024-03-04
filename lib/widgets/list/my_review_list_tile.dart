import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../square_image.dart';
import '../start_widget.dart';

class MyReviewListTile extends StatelessWidget {
  const MyReviewListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sized_18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSizeBox(sized_10),
                _title(context),
                heightSizeBox(sized_5),
                Text('2000-1-1',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_8,color: BasicColor.lightgrey2)),
                heightSizeBox(sized_10),
                _reviewImg(),
                heightSizeBox(sized_6),
                Text('설명',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10,color: BasicColor.lightgrey2)),
              ],
            ),
          ),
          heightSizeBox(sized_15),
        ],
      ),
    );
  }

  Row _title(BuildContext context) {
    return Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('가게명',style: Theme.of(context).textTheme.displaySmall,),
                      widthSizeBox(sized_5),
                      buildStarRating(5,sized_10),
                    ],
                  ),
                  Expanded(child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: sized_30,
                      height: sized_20,
                      decoration: grayDecor(sized_10),
                      child: Center(child: Text('삭제',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_8))),
                    ),
                  ))
                ],
              );
  }

  Row _reviewImg() {
    return  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // for (String imageUrl in imageUrls)
                  //   SquareImage(
                  //     img: imageUrl,
                  //     width: 78.0,
                  //     height: 52.0,
                  //   ),
                  SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_78,height: sized_52,),
                  SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_78,height: sized_52,),
                  SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_78,height: sized_52,),
                  SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_78,height: sized_52,),
              ],);
  }
}

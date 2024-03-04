import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../square_image.dart';
import '../start_widget.dart';

class ReviewListTile extends StatelessWidget {
  const ReviewListTile({super.key});

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
                heightSizeBox(sized_20),
                _title(context),
                heightSizeBox(sized_10),
                _reviewImg(),
                heightSizeBox(sized_10),
                Text('설명',style: Theme.of(context).textTheme.bodySmall),
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
                      CircleImage(img: '',size: sized_24,),
                      widthSizeBox(sized_5),
                      Text('닉네임',style: Theme.of(context).textTheme.displayMedium,),
                      widthSizeBox(sized_5),
                      Text('·',style: Theme.of(context).textTheme.displayMedium,),
                      widthSizeBox(sized_5),
                      buildStarRating(5,sized_12),
                    ],
                  ),
                  Visibility(
                    visible: false,
                    child: Expanded(child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: sized_30,
                        height: sized_20,
                        decoration: grayDecor(sized_10),
                        child: Center(child: Text('삭제',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10))),
                      ),
                    )),
                  )
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

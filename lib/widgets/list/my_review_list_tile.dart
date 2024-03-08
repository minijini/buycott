import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/data/review_model.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/utils/utility.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/basic_text.dart';
import '../../states/store_notifier.dart';
import '../square_image.dart';
import '../star_widget.dart';

class MyReviewListTile extends StatelessWidget {
  final Review review;
  final int index;
  const MyReviewListTile({super.key, required this.review, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding_side),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSizeBox(sized_10),
                _title(context),
                heightSizeBox(sized_5),
                Text('작성일 ${Utility().getDateFormat(review.regDt!)}',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_8,color: BasicColor.lightgrey2)),
                heightSizeBox(sized_10),
                Visibility(
                    visible: review.signedUrls != null,
                    child: _reviewImg()) ,
                heightSizeBox(sized_6),
                Text(review.reviewContent ?? "",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10,color: BasicColor.lightgrey2)),
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
                      Text(review.storeName ?? "",style: Theme.of(context).textTheme.displaySmall,),
                      widthSizeBox(sized_5),
                      buildStarRating(5,sized_10),
                    ],
                  ),
                  Expanded(child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        deleteReview(context,review.reviewSrno.toString());
                      },
                      child: Container(
                        width: sized_30,
                        height: sized_20,
                        decoration: grayDecor(sized_10),
                        child: Center(child: Text('삭제',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_8))),
                      ),
                    ),
                  ))
                ],
              );
  }

  Row _reviewImg() {
    return  Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:List.generate(
          review.signedUrls!.length,
              (index) =>  Padding(
                padding: const EdgeInsets.only(right: sized_5),
                child: SquareImage(img: review.signedUrls![index],width:sized_78,height: sized_78,),
              )
      ),);
  }

  void deleteReview(BuildContext context,String reviewSrno){
    Provider.of<StoreNotifier>(context, listen: false).deleteReview(context, review.storeSrno.toString(), userSrno.toString(), reviewSrno).then((value){
      context.read<StoreNotifier>().myReviewList.removeAt(index);
    }
    );
  }
}

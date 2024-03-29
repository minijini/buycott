import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/data/review_model.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/utils/utility.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/basic_text.dart';
import '../../constants/constants.dart';
import '../../states/store_notifier.dart';
import '../dialog/custom_dialog.dart';
import '../square_image.dart';
import '../star_widget.dart';

class MyReviewListTile extends StatefulWidget {
  final Review review;
  final int index;
  const MyReviewListTile({super.key, required this.review, required this.index});

  @override
  State<MyReviewListTile> createState() => _MyReviewListTileState();
}

class _MyReviewListTileState extends State<MyReviewListTile> {
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
                _title(context),
                Visibility(
                    visible: widget.review.signedUrls != null,
                    child: _reviewImg()) ,
                heightSizeBox(sized_20),
                Text(widget.review.reviewContent ?? "",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: BasicColor.lightgrey2)),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Text('작성일 ${Utility().getDateFormat(widget.review.regDt!)}',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10,color: BasicColor.lightgrey2))),
                heightSizeBox(sized_10),
              ],
            ),
          ),
          heightSizeBox(sized_15),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: sized_15),
      child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.review.storeName ?? "",style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black),),
                        widthSizeBox(sized_5),
                        Text('·',style: Theme.of(context).textTheme.displayMedium,),
                        widthSizeBox(sized_5),
                        buildStarRating(5,sized_18),
                      ],
                    ),
                    Expanded(child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          CustomDialog(funcAction: dialog_remove_review).actionDialog(context, review_remove, '아니오', '확인');
                        },
                        child: Container(
                          width: sized_30,
                          height: sized_20,
                          child: Center(child: Text('삭제',style: Theme.of(context).textTheme.displaySmall!.copyWith(decoration: TextDecoration.underline,fontSize: sized_10,color: BasicColor.lightgrey2))),
                        ),
                      ),
                    ))
                  ],
                ),
    );
  }

  Widget _reviewImg() {
    return SizedBox(
      height: widget.review.signedUrls!.isNotEmpty ? 120 : 0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
            widget.review.signedUrls!.length,
                (index) =>  Padding(
              padding: const EdgeInsets.only(right: sized_10,top: sized_20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(sized_10),
                  child: SquareImage(img: widget.review.signedUrls![index],width:sized_100,height: sized_100,)),
            )
        ),
      ),
    );
  }

  void dialog_remove_review(BuildContext context) async {
    Navigator.pop(context);
    dialog_review_delete();
  }

  void dialog_review_delete(){
    deleteReview(context,widget.review.reviewSrno.toString());
  }

  void deleteReview(BuildContext context,String reviewSrno){
    Provider.of<StoreNotifier>(context, listen: false).deleteReview(context, widget.review.storeSrno.toString(), userSrno.toString(), reviewSrno).then((value){
      context.read<StoreNotifier>().myReviewList.removeAt(widget.index);
    }
    );
  }
}

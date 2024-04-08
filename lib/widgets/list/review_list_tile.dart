import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../data/review_model.dart';
import '../../states/store_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../dialog/custom_dialog.dart';
import '../square_image.dart';
import '../star_widget.dart';

class ReviewListTile extends StatefulWidget {
  final Review review;
  final String storeSrno;
  final int index;
  const ReviewListTile({super.key, required this.review, required this.storeSrno, required this.index});

  @override
  State<ReviewListTile> createState() => _ReviewListTileState();
}

class _ReviewListTileState extends State<ReviewListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding_side),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: widget.review.reviewSignedUrls != null,
                    child: _reviewImg()) ,
                _title(context),
                heightSizeBox(sized_10),
                Text(widget.review.reviewContent ?? "" ,style: Theme.of(context).textTheme.bodySmall),
                _deleteReview(context),
                heightSizeBox(sized_20),

              ],
            ),
          ),
          divider(),
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
                        CircleImage(img: widget.review.userSignUrl,size: sized_24,),
                        widthSizeBox(sized_5),
                        Text(widget.review.nickname ?? "",style: Theme.of(context).textTheme.displayMedium,),
                        widthSizeBox(sized_5),
                        Text('·',style: Theme.of(context).textTheme.displayMedium,),
                        widthSizeBox(sized_5),
                        buildStarRating(widget.review.score??0,sized_18),
                      ],
                    ),

                  ],
                ),
    );
  }

  Visibility _deleteReview(BuildContext context) {
    return Visibility(
                  visible: userSrno == widget.review.userSrno,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){

                        CustomDialog(funcAction: dialog_remove_review).actionDialog(context, review_remove, '아니오', '확인');

                      },
                      child: Container(
                        width: sized_30,
                        height: sized_20,
                        child: Center(child: Text('삭제',style: Theme.of(context).textTheme.displaySmall!.copyWith(decoration: TextDecoration.underline,decorationColor: BasicColor.linegrey,color:BasicColor.linegrey))),
                      ),
                    ),
                  ),
                );
  }

  Widget _reviewImg() {
    return SizedBox(
      height: widget.review.reviewSignedUrls!.isNotEmpty ? 120 : 0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
              widget.review.reviewSignedUrls!.length,
                  (index) =>  Padding(
                padding: const EdgeInsets.only(right: sized_10,top: sized_20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(sized_10),
                    child: SquareImage(img: widget.review.reviewSignedUrls![index],width:sized_100,height: sized_100,)),
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
    Provider.of<StoreNotifier>(context, listen: false).deleteReview(context, widget.storeSrno, userSrno.toString(), reviewSrno).then((value){
      debugPrint('index : ${widget.index}');
      context.read<StoreNotifier>().reviewList.removeAt(widget.index);
    }
    );
  }
}

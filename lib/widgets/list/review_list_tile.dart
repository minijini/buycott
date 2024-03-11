import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/widgets/circle_image.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/review_model.dart';
import '../../states/store_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../square_image.dart';
import '../star_widget.dart';

class ReviewListTile extends StatelessWidget {
  final Review review;
  final String storeSrno;
  final int index;
  const ReviewListTile({super.key, required this.review, required this.storeSrno, required this.index});

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
                    visible: review.signedUrls != null,
                    child: _reviewImg()) ,

                _title(context),
                heightSizeBox(sized_10),
                Text(review.reviewContent ?? "" ,style: Theme.of(context).textTheme.bodySmall),
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
                        CircleImage(img: '',size: sized_24,),
                        widthSizeBox(sized_5),
                        Text("",style: Theme.of(context).textTheme.displayMedium,),
                        widthSizeBox(sized_5),
                        Text('·',style: Theme.of(context).textTheme.displayMedium,),
                        widthSizeBox(sized_5),
                        buildStarRating(review.score??0,sized_18),
                      ],
                    ),

                  ],
                ),
    );
  }

  Visibility _deleteReview(BuildContext context) {
    return Visibility(
                  visible: userSrno == review.userSrno,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        deleteReview(context,review.reviewSrno.toString());
                      },
                      child: Container(
                        width: sized_30,
                        height: sized_20,
                        child: Center(child: Text('삭제',style: Theme.of(context).textTheme.displaySmall!.copyWith(decoration: TextDecoration.underline,color:BasicColor.linegrey))),
                      ),
                    ),
                  ),
                );
  }

  Widget _reviewImg() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:List.generate(
          review.signedUrls!.length,
              (index) =>  Padding(
            padding: const EdgeInsets.only(right: sized_10,top: sized_20),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(sized_10),
                child: SquareImage(img: review.signedUrls![index],width:sized_100,height: sized_100,)),
          )
      ),);
  }



  void deleteReview(BuildContext context,String reviewSrno){
    Provider.of<StoreNotifier>(context, listen: false).deleteReview(context, storeSrno, userSrno.toString(), reviewSrno).then((value){
      debugPrint('index : $index');
      context.read<StoreNotifier>().reviewList.removeAt(index);
    }
    );
  }
}

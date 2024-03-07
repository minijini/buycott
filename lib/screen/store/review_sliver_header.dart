import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/basic_text.dart';
import '../../constants/constants.dart';
import '../../constants/padding_size.dart';

class ReviewSliverHeader extends SliverPersistentHeaderDelegate {
   final int? storeSrno;
   const ReviewSliverHeader(this.storeSrno);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 48,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding_side),
        child: Row(
          children: [
            Row(
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

            Visibility(
              visible: userSrno != null,
              child: Expanded(child:
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: (){
                        context.goNamed(reviewWriteRouteName,pathParameters: {
                          'storeSrno' : storeSrno.toString()
                        });
                      },
                      child: Text('리뷰쓰기')))
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
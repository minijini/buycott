import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/data/notice_model.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../../utils/utility.dart';

class NoticeListTile extends StatelessWidget {
  final NoticeModel noticeModel;
  const NoticeListTile({super.key, required this.noticeModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding_side,vertical: sized_12),
      child: Row(
        children: [
          Expanded(child: Text(noticeModel.noticeSubject ?? '' , style: Theme.of(context).textTheme.bodyMedium,maxLines: 1,overflow:TextOverflow.ellipsis)),
          widthSizeBox(sized_5),
          Text(Utility().getDateFormat(noticeModel.regDt!),style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10,color: BasicColor.lightgrey2),)

        ],
      ),
    );
  }
}

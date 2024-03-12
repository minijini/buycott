import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/utility.dart';
import '../../widgets/style/container.dart';

class NoticeDetailScreen extends StatelessWidget {
  final String subject;
  final String content;
  final String date;
  const NoticeDetailScreen({super.key, required this.subject, required this.content, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "공지사항",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: false,
          titleSpacing: -10,
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,))
      ),

      body: Container(
        color: BasicColor.linegrey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding_side,vertical: sized_12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(child: Text(subject , style: Theme.of(context).textTheme.bodyMedium,maxLines: 2,overflow:TextOverflow.ellipsis)),
                  widthSizeBox(sized_5),
                  Text(Utility().getDateFormat(date),style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10,color: BasicColor.lightgrey2),)
                ],
              ),
            ),
            Expanded(child: SingleChildScrollView(child: Padding(
              padding: const EdgeInsets.symmetric(vertical:sized_20 ,horizontal: padding_side),
              child: Text(content,style: Theme.of(context).textTheme.bodyMedium,),
            )))
          ],
        ),
      ),
    );
  }
}

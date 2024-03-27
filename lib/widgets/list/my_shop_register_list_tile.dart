import 'package:auto_size_text/auto_size_text.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/data/store_model.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

class MyShopRegisterListTile extends StatelessWidget {
  final StoreModel storeModel;
  const MyShopRegisterListTile({super.key, required this.storeModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding_side,vertical: sized_20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(storeModel.storeName ?? "",style: Theme.of(context).textTheme.displayLarge,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    heightSizeBox(sized_5),
                    Text(storeModel.storeAddress ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2))
                  ],
                ),
              ),
              widthSizeBox(sized_18),
              Container(
                  padding: EdgeInsets.all(sized_5),
                  height: sized_23,
                  constraints: const BoxConstraints(
                      minWidth: sized_40, // Set the minimum width
                  ),
                  decoration: grayDecor(sized_15),child: Center(child: AutoSizeText(storeModel.validYn == "N" ? '승인 대기 중' : '승인 완료',style: Theme.of(context).textTheme.bodySmall!.copyWith(color:BasicColor.lightgrey2))))
            ],
          ),
        ),
      ],
    );
  }
}

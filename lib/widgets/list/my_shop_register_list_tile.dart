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
              // Text('삭제',style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.underline,color:BasicColor.lightgrey2))
            ],
          ),
        ),
      ],
    );
  }
}

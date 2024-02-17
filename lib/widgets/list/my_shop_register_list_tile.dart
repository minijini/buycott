import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

class MyShopRegisterListTile extends StatelessWidget {
  const MyShopRegisterListTile({super.key});

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
                heightSizeBox(sized_10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('제목',style: Theme.of(context).textTheme.bodyMedium,),
                    Icon(Icons.chevron_right,size: sized_16,)
                  ],
                ),
                heightSizeBox(sized_5),
                Text('설명',style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
          ),
          heightSizeBox(sized_15),
        ],
      ),
    );
  }
}

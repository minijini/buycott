import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../square_image.dart';

class MainShopListTile extends StatelessWidget {
   MainShopListTile({super.key});



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: sized_6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_104,height: sized_50,),
          SizedBox(height: sized_10,),
          SizedBox(
              width: sized_104,
              child: AutoSizeText('세상의 이런일이 526회',style: Theme.of(context).textTheme.displaySmall,maxLines: 1, // Restrict to a single line
                overflow: TextOverflow.ellipsis,)),
          SizedBox(height: sized_6,),
          SizedBox(
              width: sized_104,
              child: AutoSizeText('세상의 이 이런일이세상의 이 이런일이세상의 이 이런일이 ',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10),maxLines: 3, // Restrict to a single line
                overflow: TextOverflow.ellipsis,)),

        ],
      ),
    );
  }
}



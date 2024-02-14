import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../square_image.dart';

class MainShopListTile extends StatelessWidget {
  const MainShopListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_104,height: sized_50,),
          SizedBox(height: sized_10,),
          Text('제목',style: Theme.of(context).textTheme.bodyMedium,),
          SizedBox(height: sized_6,),
          Text('설명',style: Theme.of(context).textTheme.bodySmall,),
        ],
      ),
    );
  }
}

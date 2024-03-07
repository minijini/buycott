import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/widgets/square_image.dart';
import 'package:flutter/material.dart';

import '../star_widget.dart';

class ShopListTile extends StatelessWidget {
  const ShopListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SquareImage(img: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9s3jRR7f_W9MrFLc49-3mR9Zh-osMXgIknUpAeTBuFA&s'),
          Text(''),
          buildStarRating(5,sized_40),
          Text('')


        ],
      ),
    );
  }

}

import 'package:buycott/widgets/square_image.dart';
import 'package:flutter/material.dart';

class ShopListTile extends StatelessWidget {
  const ShopListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SquareImage(img: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9s3jRR7f_W9MrFLc49-3mR9Zh-osMXgIknUpAeTBuFA&s'),
          Text(''),
          buildStarRating(5),
          Text('')


        ],
      ),
    );
  }

  Widget buildStarRating(int star) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        star,
            (index) => Icon(
          Icons.star,
          color: Colors.yellow,
          size: 40.0,
        ),
      ),
    );
  }

}

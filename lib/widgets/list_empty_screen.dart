import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

import '../constants/padding_size.dart';
import '../constants/screen_size.dart';
import '../utils/color/basic_color.dart';

class ListEmptyScreen extends StatelessWidget {
  final String title;
  const ListEmptyScreen({
    super.key, required this.title,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size!.width,
      height: size!.height,
      child: Column(
        children: [
          heightSizeBox(sized_180),
          Text(title,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4),)
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';

Divider list_divider(){
  return const Divider(
    height: sized_5,
    thickness: 0.7,
    color: BasicColor.linegrey3,
    indent: sized_5,
    endIndent: sized_5,
  );
}
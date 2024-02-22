import 'package:buycott/constants/padding_size.dart';
import 'package:flutter/material.dart';

import '../../utils/color/basic_color.dart';

ButtonStyle white_btn_style() {
  return TextButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ));
}

ButtonStyle disable_btn_style() {
  return TextButton.styleFrom(
      backgroundColor: BasicColor.lightgrey,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sized_5),
      ));
}

ButtonStyle primary_btn_style() {
  return TextButton.styleFrom(
      backgroundColor: BasicColor.primary,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sized_5),
      ));
}

ButtonStyle primary_btn_size_style(double circular) {
  return TextButton.styleFrom(
      backgroundColor: BasicColor.primary2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circular),
      ));
}



ButtonStyle grey_btn_style() {
  return TextButton.styleFrom(
      backgroundColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ));
}



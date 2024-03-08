import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';

InputDecoration drop_down_Decor(String icon,Color color, Color errorColor) {
  return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.all(sized_10),
        child: Image.asset(
          icon,
          width: 19,
          height: 12,
          fit: BoxFit.contain,
        ),
      ),
      enabledBorder: underlineInputBorder(color),
      focusedErrorBorder: underlineInputBorder(errorColor),
      focusedBorder: underlineInputBorder(color),
      filled: false,
      fillColor: Colors.grey[100]);
}

InputDecoration textInputDecor_grey(double sideSize,{String? hint,String? labelText}){
  return InputDecoration(
    hintText: hint,
    labelText: labelText,
    contentPadding: EdgeInsets.only(left: sized_10,top: sized_12,bottom: sized_12),
    enabledBorder: outlineBorder(BasicColor.linegrey,sized_1,sideSize),
    focusedBorder: outlineBorder(BasicColor.linegrey,sized_1,sideSize),
    errorBorder: outlineBorder(BasicColor.linegrey,sized_1,sideSize),
    focusedErrorBorder: outlineBorder(BasicColor.linegrey,sized_1,sideSize),
    filled: false,
  );
}

InputDecoration textInputDecor_none(BuildContext context,{String? hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize:16,color: BasicColor.linegrey,),
    isDense: true, //공백없애기
    contentPadding: EdgeInsets.only(left: sized_10,top: sized_9,bottom: sized_9),
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    filled: true,
    fillColor: BasicColor.lightgrey3
  );
}

UnderlineInputBorder underlineInputBorder(Color color) {
  return UnderlineInputBorder(
    borderSide: BorderSide(color: color),
  );
}

OutlineInputBorder outlineBorder(Color color ,double borderWidth, double size) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: borderWidth
    ),
    borderRadius: BorderRadius.circular(size),
  );
}

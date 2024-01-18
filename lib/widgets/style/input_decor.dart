import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';

InputDecoration textInputDecor(String hint, String icon, Color color, Color errorColor ,{Widget? suffixIcon}) {
  return InputDecoration(
      suffixIcon: suffixIcon,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(sized_10),
        child: Image.asset(
          icon,
          width: 19,
          height: 12,
          fit: BoxFit.contain,
        ),
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: color,
      ),
      errorBorder: underlineInputBorder(errorColor),
      errorStyle: TextStyle(color: errorColor),
      enabledBorder: underlineInputBorder(color),
      focusedErrorBorder: underlineInputBorder(errorColor),
      focusedBorder: underlineInputBorder(color),
      filled: false,
      fillColor: Colors.grey[100]);
}

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

InputDecoration drop_down_Decor2(Color color, Color errorColor) {
  return InputDecoration(
      prefixIcon: const Padding(
        padding: EdgeInsets.all(sized_5),
        child: SizedBox(width: 15, height: 10,child: Icon(Icons.account_balance_outlined,color: BasicColor.linegrey2,))
      ),
      enabledBorder: underlineInputBorder(color),
      focusedErrorBorder: underlineInputBorder(errorColor),
      focusedBorder: underlineInputBorder(color),
      filled: false,
      fillColor: Colors.grey[100]);
}

InputDecoration textInputDecor2(String hint,BuildContext context) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    hintText: hint,
    hintStyle: Theme.of(context)
        .textTheme
        .displaySmall!
        .copyWith(color: BasicColor.warmgrey,),
    errorBorder: outlineBorder(BasicColor.primary),
    enabledBorder: outlineBorder(BasicColor.linegrey2),
    focusedErrorBorder: outlineBorder(BasicColor.primary),
    focusedBorder: outlineBorder(BasicColor.linegrey2),
    filled: false,
    suffixIcon: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('송이',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: BasicColor.warmgrey)),
      ],
    ),
  );
}

InputDecoration textInputDecor3(String hint,BuildContext context) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

    hintText: hint,
    hintStyle: Theme.of(context)
        .textTheme
        .displaySmall!
        .copyWith(color: BasicColor.warmgrey,),
    errorBorder: outlineBorder(BasicColor.primary),
    enabledBorder: outlineBorder(BasicColor.linegrey2),
    focusedErrorBorder: outlineBorder(BasicColor.primary),
    focusedBorder: outlineBorder(BasicColor.linegrey2),
    filled: false,
  );
}

InputDecoration textInputDecor_none(BuildContext context,{String? hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: Theme.of(context)
        .textTheme
        .displaySmall!
        .copyWith(color: BasicColor.warmgrey,),
    isDense: true, //공백없애기
    contentPadding: EdgeInsets.only(left: sized_10),
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    filled: false,
  );
}

UnderlineInputBorder underlineInputBorder(Color color) {
  return UnderlineInputBorder(
    borderSide: BorderSide(color: color),
  );
}

OutlineInputBorder outlineBorder(Color color) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: color,
    ),
    borderRadius: BorderRadius.circular(sized_2),
  );
}

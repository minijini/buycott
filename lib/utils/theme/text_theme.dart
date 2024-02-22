import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/basic_color.dart';

class BasicTextTheme{
  static TextTheme lightTextTheme = const TextTheme(
    //Pretendard-Regular
    bodyLarge:  TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18.0,
      color: Colors.black,
    ),
    bodyMedium:  TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Colors.black,
    ),
    bodySmall:  TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      color: Colors.black,
    ),

    //Pretendard-SemiBold
    displayLarge:  TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    displayMedium:  TextStyle(
      fontSize: 14.0,
      fontWeight:FontWeight.w600,
      color:  Colors.black,
    ),
    displaySmall:  TextStyle(
      fontSize: 12,
      fontWeight:FontWeight.w600,
      color: Colors.black,
    ),


    //Pretendard-Bold
    titleSmall:  TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16.0,
      color: BasicColor.lightgrey2,
    ),

    titleMedium:  TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 18.0,
      color: Colors.black,
    ),

    //semibold
    titleLarge:  TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 24.0,
      color: Colors.black,
    )

    // GoogleFonts.notoSans(
    //   fontSize: 24.0,
    //   fontWeight: FontWeight.bold,
    //   color: Colors.black,
    // ),
  );
}
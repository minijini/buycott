import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/basic_color.dart';

class BasicTextTheme{
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.notoSansMono(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.notoSans(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.notoSans(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: BasicColor.lightgrey2,
    ),
    displayLarge: GoogleFonts.notoSans(
      fontSize: 22.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.notoSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: BasicColor.lightblack,
    ),
    displaySmall: GoogleFonts.notoSans(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    titleSmall: GoogleFonts.notoSans(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.notoSans(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleLarge: GoogleFonts.notoSans(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}
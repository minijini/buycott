import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/basic_color.dart';

class BasicTextTheme{
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.notoSansMono(
      fontSize: 17.0,
      fontWeight: FontWeight.w600,
      color: BasicColor.primary,
    ),
    bodyMedium: GoogleFonts.notoSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: BasicColor.lightblack2,
    ),
    bodySmall: GoogleFonts.notoSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: BasicColor.warmgrey,
    ),
    displayLarge: GoogleFonts.notoSans(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.notoSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: BasicColor.lightblack,
    ),
    displaySmall: GoogleFonts.notoSans(
      fontSize: 12.7,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.notoSans(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}
import 'package:buycott/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../color/basic_color.dart';

class BasicTheme {
  static ThemeData light() {
    return ThemeData(
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.white;
          },
        ),
        checkColor: MaterialStateProperty.all(BasicColor.primary),
        side: const BorderSide(color: Colors.white, width: 0.7),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(BasicColor.yellow),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(
          color: BasicColor.primary,
        ),

        backgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: BasicColor.primary2,
          unselectedItemColor: Colors.white,
          selectedLabelStyle:
              TextStyle(color: BasicColor.primary, fontSize: 10)),
      textTheme: BasicTextTheme.lightTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BasicColor.primary, width: sized_5),
          borderRadius: BorderRadius.circular(sized_10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BasicColor.primary, width: sized_5),
          borderRadius: BorderRadius.circular(sized_10),
        ),
        suffixIconColor: BasicColor.primary,
      ),
    );
  }
}

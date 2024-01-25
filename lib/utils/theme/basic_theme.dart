import 'package:buycott/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../color/basic_color.dart';

class BasicTheme{
  static ThemeData light() {
    return ThemeData(
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
              (states) {

                  return Colors.white;

          },
        ),
        checkColor:  MaterialStateProperty.all(BasicColor.primary),
        side: const BorderSide(color: Colors.white ,width: 0.7),
      ),
      radioTheme: RadioThemeData(
        fillColor:  MaterialStateProperty.all(BasicColor.yellow),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: BasicColor.primary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: BasicColor.primary,
        selectedLabelStyle: TextStyle(color:BasicColor.primary,fontSize: 10)
      ),
      textTheme: BasicTextTheme.lightTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: Colors.white,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  return ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade900,
      elevation: 24,
    ),
    fontFamily: 'Roboto',
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey.shade900,

    colorScheme: ColorScheme.dark(
      primary: Colors.grey.shade900,
      secondary: Colors.lightBlue.shade600,
      secondaryVariant: Color(0xFFF0AC33),
      background: Colors.grey.shade900,


    )
  );
}

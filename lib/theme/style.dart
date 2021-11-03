import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(),
    primaryColor: Colors.grey.shade900,
    accentColor: Colors.cyan,
    fontFamily: 'Roboto',
  );
}

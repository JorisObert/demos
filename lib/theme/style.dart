import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: Colors.blueGrey.shade800
    ),
    primaryColor: Colors.blueGrey.shade900,
    scaffoldBackgroundColor: Colors.blueGrey.shade900,
    canvasColor: Colors.blueGrey.shade800,

    accentColor: Colors.amber,
    fontFamily: 'Roboto',
  );
}

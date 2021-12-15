import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.amber,
    canvasColor: Colors.blueGrey.shade900,
    scaffoldBackgroundColor: Colors.blueGrey.shade900,
    fontFamily: 'Roboto',
  );
}

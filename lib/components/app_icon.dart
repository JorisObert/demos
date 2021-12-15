import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key, this.size = 14.0}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.sensors, size: size,);
  }
}

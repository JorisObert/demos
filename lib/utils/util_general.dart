import 'package:flutter/material.dart';

Color getColor(int index){
  switch(index){
    case 0:
      return Colors.purpleAccent;
    case 1:
      return Colors.blueGrey;
    case 2:
      return Colors.redAccent;
    default:
      return Colors.purpleAccent;
  }
}
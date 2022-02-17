import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key, this.size = 16}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'D',style: GoogleFonts.expletusSans(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondaryVariant,
    ),
    );
  }
}

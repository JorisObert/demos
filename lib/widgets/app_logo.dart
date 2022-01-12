import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key, this.size = 24.0}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'D',
        style: GoogleFonts.expletusSans(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
        children: const <TextSpan>[
          TextSpan(text: 'emos', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

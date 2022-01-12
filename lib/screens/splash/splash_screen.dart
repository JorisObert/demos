import 'package:auto_size_text/auto_size_text.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/screens/main/main_screen.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/src/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _logoAnimationDuration = 2000;
  final _launchTimer = 2000;

  var _logoOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    //logo anim
    Future.delayed(Duration.zero, () {
      setState(() {
        _logoOpacity = 1.0;
      });
    });

    //go to main
    Future.delayed(Duration(milliseconds: _launchTimer), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: _splashBody(),
        ),
      ),
    );
  }

  Widget _splashBody() {
    return Center(
      child: AnimatedOpacity(
        opacity: _logoOpacity,
        duration: Duration(milliseconds: _logoAnimationDuration),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(size: 36,),
            SizedBox(
              height: 16.0,
            ),
            Text('Let your voice be heard !', style: GoogleFonts.expletusSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),),
          ],
        ),
      ),
    );
  }
}

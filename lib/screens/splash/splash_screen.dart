import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
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
    context.read<DemosUserProvider>().loginUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).accentColor,
        child: _splashBody(),
      ),
    );
  }

  Widget _splashBody() {
    return Center(
      child: AnimatedOpacity(
        opacity: _logoOpacity,
        duration: Duration(milliseconds: _logoAnimationDuration),
        child: Text('DEMOS'),
      ),
    );
  }
}

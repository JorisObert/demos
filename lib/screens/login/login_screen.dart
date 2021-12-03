import 'package:demos/services/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login to vote !', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
                _buttonSeparator,
                Text('create an acount and make your voice count !'),
                _buttonSeparator,
                _buttonSeparator,
                SignInButton(
                  Buttons.GoogleDark,
                  onPressed: ()=> SocialLogin.signInWithGoogle(),
                ),
                _buttonSeparator,
                SignInButton(
                  Buttons.AppleDark,
                  onPressed: () {},
                ),
                _buttonSeparator,
                SignInButton(
                  Buttons.Twitter,
                  onPressed: () {},
                ),
                _buttonSeparator,
                SignInButton(
                  Buttons.FacebookNew,
                  onPressed: ()=> SocialLogin.signInWithFacebook(),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buttonSeparator{
    return SizedBox(height: 16.0,);
  }
}

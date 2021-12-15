import 'package:demos/components/app_icon.dart';
import 'package:demos/services/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.onClosed}) : super(key: key);

  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppIcon(),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Create your pool',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(onPressed: onClosed, icon: Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: Center(
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
                        onPressed: ()async{
                           var credentiels = await SocialLogin.signInWithGoogle();
                        },
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
          ],
        ),
      ),
    );

  }

  Widget get _buttonSeparator{
    return SizedBox(height: 16.0,);
  }
}

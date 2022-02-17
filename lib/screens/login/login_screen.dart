import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/src/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.onClosed, required this.onLoggedIn}) : super(key: key);

  final VoidCallback onClosed;
  final VoidCallback onLoggedIn;

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
                      SizedBox(
                        width: 8.0,
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
                      Text(
                        'Login to vote !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      _buttonSeparator,
                      Text('create an acount and make your voice count !'),
                      _buttonSeparator,
                      _buttonSeparator,
                      SignInButton(
                        Buttons.GoogleDark,
                        onPressed: () async {
                          await context
                              .read<DemosUserProvider>()
                              .loginUser(loginProvider: LoginProvider.GOOGLE);
                          onLoggedIn();
                        },
                      ),
                      _buttonSeparator,
                      SignInButton(
                        Buttons.AppleDark,
                        onPressed: () async {
                          context
                              .read<DemosUserProvider>()
                              .loginUser(loginProvider: LoginProvider.APPLE);
                          onLoggedIn();
                        },
                      ),
                      _buttonSeparator,
                      SignInButton(
                        Buttons.Twitter,
                        onPressed: () async {
                          context
                              .read<DemosUserProvider>()
                              .loginUser(loginProvider: LoginProvider.TWITTER);
                          onLoggedIn();
                        },
                      ),
                      _buttonSeparator,
                      SignInButton(
                        Buttons.FacebookNew,
                        onPressed: () {
                          context
                              .read<DemosUserProvider>()
                              .loginUser(loginProvider: LoginProvider.FACEBOOK);
                          onLoggedIn();
                        },
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

  Widget get _buttonSeparator {
    return SizedBox(
      height: 16.0,
    );
  }
}

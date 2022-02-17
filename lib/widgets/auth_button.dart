import 'package:demos/providers/demos_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key, required this.authStatus, required this.child}) : super(key: key);

  final Function(AuthStatus) authStatus;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        authStatus(context.read<DemosUserProvider>().authStatus);
      },
      child: child,
    );
  }
}

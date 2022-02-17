import 'package:cached_network_image/cached_network_image.dart';
import 'package:demos/models/demos_user.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/screens/splash/splash_screen.dart';
import 'package:demos/widgets/user_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DemosUser? user = context.read<DemosUserProvider>().user;

    double size = 100.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: user != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(),
                UserPicture(
                  url: context.read<DemosUserProvider>().user?.profilePicUrl,
                  size: 100,
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  user.displayName ?? 'user${user.id!.substring(0, 10)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 32,
                ),
                TextButton(
                    onPressed: () async {
                      await context.read<DemosUserProvider>().logoutUser();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          decoration: TextDecoration.underline),
                    )
                ),
                TextButton(
                    onPressed: () {
                      showAlertDialog(context);
                    },
                    child: Text(
                      'Delete account',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          decoration: TextDecoration.underline),
                    )
                ),
              ],
            )
          : Text('no user'),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(
          color: Theme.of(context).colorScheme.secondary),),
      onPressed:  () {},
    );
    Widget continueButton = TextButton(
      child: Text("Delete", style: TextStyle(
          color: Theme.of(context).colorScheme.secondaryVariant),),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Caution"),
      content: Text("This action is irreversible."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

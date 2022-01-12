import 'package:flutter/material.dart';

class NoMorePoolsScreen extends StatelessWidget {
  const NoMorePoolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('No more pools to show :('),
        SizedBox(height: 16,),
        Text('Edit your filters or create a new pool !'),
        SizedBox(height: 42,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Icon(Icons.tune, size: 28,),
              backgroundColor: Colors.orangeAccent,
              radius: 32,
              foregroundColor: Colors.white,
            ),
            SizedBox(width: 32,),
            CircleAvatar(
              child: Icon(Icons.add, size: 28,),
              backgroundColor: Colors.lightBlue,
              radius: 32,
              foregroundColor: Colors.white,
            ),
          ],
        )
      ],
    );
  }
}

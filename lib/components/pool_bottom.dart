import 'package:demos/components/pool_bar.dart';
import 'package:flutter/material.dart';

class PoolBottom extends StatelessWidget {
  PoolBottom({Key? key, required this.choices}) : super(key: key);

  final List<Choice> choices;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${_nbrVotes()} votes'),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.share),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {}),
            SizedBox(
              width: 16.0,
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  int _nbrVotes() {
    return choices.fold(0, (i, el) {
      return i + (el.nbrVotes);
    });
  }
}

import 'package:demos/components/vote_bar.dart';
import 'package:demos/utils/util_general.dart';
import 'package:flutter/material.dart';

class VoteCaption extends StatelessWidget {

  final List<Choice> choices;

  const VoteCaption({Key? key, required this.choices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _createChildren(),
    );
  }

  List<Widget> _createChildren() {
    return List.generate(choices.length, (index) => _captionItem(choices[index], index));

  }

  Widget _captionItem(Choice choice, int index){
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: getColor(index),
        ),
        Text(choice.title),
      ],
    );
  }
}

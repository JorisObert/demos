import 'package:demos/utils/util_general.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VoteBar extends StatelessWidget {

  final List<Choice> choices;

  const VoteBar({Key? key, required this.choices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: _createChildren(),
      ),
    );
  }

  List<Widget> _createChildren() {
    return List.generate(choices.length, (index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LinearPercentIndicator(
        backgroundColor: Colors.grey,
        animation: true,
        lineHeight: 16.0,

        percent: _getFlex(choices[index].value),
      ),
    ));

  }

  double _getFlex(int value){
    int total = choices.fold(0, (sum, item) => sum + item.value);
    print('value is ${total/value}');
    return value/total;
  }
}

class Choice{
  final String title;
  final int value;

  Choice(this.title, this.value);
}



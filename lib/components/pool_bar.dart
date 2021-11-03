import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class PoolBar extends StatelessWidget {
  final List<Choice> choices;
  final String voteId;

  const PoolBar({Key? key, required this.choices, required this.voteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _createChildren(context),
      ),
    );
  }

  List<Widget> _createChildren(BuildContext context) {
    return List.generate(choices.length, (index) {
      int nbrVoters = choices[index].nbrVotes;
      double percent = _getFlex(nbrVoters);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            LinearPercentIndicator(
              backgroundColor: Colors.grey,
              addAutomaticKeepAlive: true,
              animation: false,
              animateFromLastPercent: true,
              lineHeight: 32.0,
              progressColor: Colors.blueGrey,
              percent: percent,
              padding: const EdgeInsets.all(16.0),
            ),
            Positioned.fill(
              left: 16.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: nbrVoters > 0
                        ? '${(percent * 100).toStringAsFixed(1)}% '
                        : '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: choices[index].title,
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () => context
                        .read<PoolProvider>()
                        .addVote(voteId, choices[index]),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                          '+',
                          style: TextStyle(color: Colors.green),
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  double _getFlex(int? value) {
    if (value == null) return 0.0;
    int total = choices.fold(0, (sum, item) => sum + (item.nbrVotes));
    return total > 0 ? value / total : 0;
  }
}

class Choice {
  final String title;
  final int nbrVotes;

  Choice(this.title, {this.nbrVotes = 0});
}

import 'package:demos/models/choice.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class PoolBarList extends StatelessWidget {
  final List<Choice> choices;
  final String poolId;

  PoolBarList({Key? key, required this.choices, required this.poolId})
      : super(key: key);

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: NotificationListener<OverscrollNotification>(
        onNotification: (OverscrollNotification value) {
          if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
            if (controller.offset != 0) controller.jumpTo(0);
            return true;
          }
          if (controller.offset + value.overscroll >= controller.position.maxScrollExtent) {
            if (controller.offset != controller.position.maxScrollExtent) controller.jumpTo(controller.position.maxScrollExtent);
            return true;
          }
          controller.jumpTo(controller.offset + value.overscroll);
          return true;
        },
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.transparent,
            child: ListView(
              controller: controller,
              shrinkWrap: true,

              children: _createChildren(context),
            ),
          ),
        ),
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
                        .saveVote(choices[index], context.read<DemosUserProvider>().user?.getUserId(), poolId),
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

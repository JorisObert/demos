import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class PoolBarList extends StatefulWidget {
  final Pool pool;

  PoolBarList({Key? key, required this.pool})
      : super(key: key);

  @override
  State<PoolBarList> createState() => _PoolBarListState();
}

class _PoolBarListState extends State<PoolBarList> {
  ScrollController controller = ScrollController();

  bool hasVoted = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
    return List.generate(widget.pool.choices!.length, (index) {
      int nbrVoters = widget.pool.choices![index].nbrVotes;
      double percent = _getFlex(nbrVoters);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: (){
            print(hasVoted);
            if(!hasVoted){
              setState(() {
                hasVoted = true;
              });
              context
                  .read<PoolProvider>()
                  .saveVote(widget.pool.choices![index], context.read<DemosUserProvider>().firebaseUser!.uid, widget.pool.id);
            }
          },
          child: Stack(
            children: [
              LinearPercentIndicator(
                backgroundColor: Colors.grey.shade900,
                addAutomaticKeepAlive: true,
                animation: true,
                animateFromLastPercent: true,
                lineHeight: 28.0,
                progressColor: Theme.of(context).colorScheme.secondary,
                percent: percent,
                padding: const EdgeInsets.all(14.0),
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
                            text: widget.pool.choices![index].title,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  double _getFlex(int? value) {
    if (value == null) return 0.0;
    int total = widget.pool.choices!.fold(0, (int sum, item) => sum + (item.nbrVotes));
    return total > 0 ? value / total : 0;
  }


}

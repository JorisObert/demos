import 'package:auto_size_text/auto_size_text.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_bar_list.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_hashtag_widget.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_item_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'components/pool_bottom.dart';

class PoolItem extends StatefulWidget {
  final Pool pool;
  final List<Choice> choices;
  final VoidCallback anonymousClick;
  final VoidCallback hasVoted;

  const PoolItem({Key? key, required this.pool, required this.anonymousClick, required this.choices, required this.hasVoted}) : super(key: key);

  @override
  State<PoolItem> createState() => _PoolItemState();
}

class _PoolItemState extends State<PoolItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            PoolItemTopBar(pool: widget.pool),
            PoolHashtagsWidget(hashtags: widget.pool.hashtags,),
            SizedBox(height: 32.0,),
            _titleWidget(),
            !context.read<DemosUserProvider>().isLoggedIn ? GestureDetector(
              onTap: widget.anonymousClick,
              child: PoolBarList(
                pool: widget.pool,
                choiceClickedId: (choiceId)=>print('null'),
              ),
            ):PoolBarList(
              pool: widget.pool,
              choiceClickedId: (choiceId){
                setState(() {
                  widget.pool.choices!.firstWhere((choice) => choice.id == choiceId).nbrVotes++;
                  widget.pool.votes = [Vote(userId: context.read<DemosUserProvider>().user!.id, choiceId: choiceId)];
                });
                widget.hasVoted();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 38.0),
              child: PoolBottom(
                  totalVotes: widget.pool.choices!.fold(0, (acc, cur) => acc + cur.nbrVotes),
                  poolId: widget.pool.id!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AutoSizeText(
          widget.pool.title,
          maxFontSize: 28,
          minFontSize: 10,
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_bar_list.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_hashtag_widget.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_item_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'components/pool_bottom.dart';

class PoolItem extends StatelessWidget {
  final Pool pool;
  final List<Choice> choices;
  final VoidCallback anonymousClick;

  const PoolItem({Key? key, required this.pool, required this.anonymousClick, required this.choices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          PoolItemTopBar(pool: pool),
          PoolHashtagsWidget(hashtags: pool.hashtags,),
          SizedBox(height: 32.0,),
          _titleWidget(),
          (context.read<DemosUserProvider>().firebaseUser?.isAnonymous ?? true) ? GestureDetector(
            onTap: anonymousClick,
            child: PoolBarList(
              pool: pool,
            ),
          ):PoolBarList(
            pool: pool,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 38.0),
            child: PoolBottom(
                totalVotes: pool.choices!.fold(0, (acc, cur) => acc + cur.nbrVotes),
                poolId: pool.id!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AutoSizeText(
          pool.title,
          maxFontSize: 28,
          minFontSize: 10,
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

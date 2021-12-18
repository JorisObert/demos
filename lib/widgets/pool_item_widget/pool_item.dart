import 'package:auto_size_text/auto_size_text.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_bar.dart';

import 'package:demos/widgets/pool_item_widget/components/pool_item_top_bar.dart';
import 'package:flutter/material.dart';

import 'components/pool_bottom.dart';

class PoolItem extends StatelessWidget {
  final Pool pool;

  const PoolItem({Key? key, required this.pool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Choice> choicesList = pool.choices.entries
        .map((entry) => Choice(entry.key, nbrVotes: entry.value))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PoolItemTopBar(pool: pool),
          Expanded(
            child: Column(

              children: [
                Expanded(flex: 3,child: _titleWidget()),
                Expanded(
                  flex: choicesList.length,
                  child: PoolBar(
                    voteId: pool.id!,
                    choices: choicesList,
                  ),
                ),
              ],
            ),
          ),
          PoolBottom(choices: choicesList),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Center(
      child: AutoSizeText(
        pool.title,
        maxFontSize: 36,
        minFontSize: 10,
        style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

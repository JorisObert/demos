import 'package:auto_size_text/auto_size_text.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_bar_list.dart';
import 'package:demos/widgets/pool_item_widget/components/pool_item_top_bar.dart';
import 'package:flutter/material.dart';

import 'components/pool_bottom.dart';

class PoolItem extends StatelessWidget {
  final Pool pool;

  const PoolItem({Key? key, required this.pool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Choice> choicesList = List<Choice>.from(pool.choices!);
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
                  child: PoolBarList(
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
        pool.title!,
        maxFontSize: 36,
        minFontSize: 10,
        style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

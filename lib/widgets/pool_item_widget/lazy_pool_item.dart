
import 'package:demos/models/pool.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LazyPollItem extends StatefulWidget {
  LazyPollItem({Key? key, required this.voteId}) : super(key: key);

  final String voteId;

  @override
  State<LazyPollItem> createState() => _LazyPollItemState();
}

class _LazyPollItemState extends State<LazyPollItem> {
  late Future<Pool?> _future;

  @override
  void initState() {
    //_future = context.read<PoolProvider>().getPoolById(widget.voteId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pool?>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<Pool?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return PoolItem(pool: snapshot.data!);
        }
        return Container(
            width: 50, height: 50, child: CircularProgressIndicator());
      },
    );
  }
}

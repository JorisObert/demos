import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/pools/components/filter_bar.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VotedPoolsScreen extends StatefulWidget {
  @override
  _VotedPoolsScreenState createState() => _VotedPoolsScreenState();
}

class _VotedPoolsScreenState extends State<VotedPoolsScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      context.read<PoolProvider>().getUserVotedPools(userId: context.read<DemosUserProvider>().user!.getUserId());
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Pool> votes = context.watch<PoolProvider>().userVotedPools;
    return Scaffold(
      body: Column(
        children: [
          FilterBar(),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: votes.length,
              controller: _pageController,
              pageSnapping: true,
              onPageChanged: (index) {
                if (index >= votes.length - 1) {
                  context.read<PoolProvider>().getPools(userId: context.read<DemosUserProvider>().user!.getUserId());
                }
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: PoolItem(
                    pool: votes[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

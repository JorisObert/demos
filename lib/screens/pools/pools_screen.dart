import 'package:demos/components/pool_item.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoolsScreen extends StatefulWidget {
  @override
  _PoolsScreenState createState() => _PoolsScreenState();
}

class _PoolsScreenState extends State<PoolsScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      context.read<PoolProvider>().getPools();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Pool> votes = context.watch<PoolProvider>().pools;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: votes.length,
              controller: _pageController,
              onPageChanged: (index) {
                if (index >= votes.length - 1) {
                  context.read<PoolProvider>().getPools();
                }
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
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

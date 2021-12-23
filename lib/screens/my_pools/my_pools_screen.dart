import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPoolsScreen extends StatefulWidget {
  @override
  _MyPoolsScreenState createState() => _MyPoolsScreenState();
}

class _MyPoolsScreenState extends State<MyPoolsScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<PoolProvider>().getUserPools(userId: context.read<DemosUserProvider>().user!.getUserId());
  }

  @override
  Widget build(BuildContext context) {
    List<Pool> userPools = context.watch<PoolProvider>().userPools;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: userPools.length,
              controller: _pageController,
              onPageChanged: (index) {
                print('page has changed $index');
                if (index >= userPools.length - 1) {
                  context.read<PoolProvider>().getUserPools(userId: context.read<DemosUserProvider>().user!.getUserId());
                }
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PoolItem(
                    pool: userPools[index],
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

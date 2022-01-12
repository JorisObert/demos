import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/filter/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> filters = context.select((PoolProvider p) => p.filters);
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: _constructFiltersItem(filters),
                    ),
                  ),
                  new Icon(Icons.tune),
                ],
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.grey.shade400,
          )
        ],
      ),
    );
  }

  List<Widget> _constructFiltersItem(Map<String, dynamic> filters){
    List<Widget> widgets = [];
    filters.remove(USER_ID_KEY);
    filters.forEach((key, value) {
      if(value != null){
        widgets.add(filterItem(value));
      }
    });
    return widgets;
  }

  Widget filterItem(dynamic filter){
    String? title;

    if(filter.runtimeType == PoolState){
      title = _convertPoolState(filter);
    }

    if(filter.runtimeType == PoolOrder){
      title = _convertPoolOrder(filter);
    }

    if(filter.runtimeType == VoteFilter){
      title = _convertVoteFilter(filter);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
          child: Text('${title}', style: TextStyle(fontSize: 11),),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }

  String _convertPoolState(PoolState poolState) {
    switch (poolState) {
      case PoolState.LIVE:
        return 'LIVE';
      case PoolState.FINISHED:
        return 'FINISHED';
    }
  }

  String _convertVoteFilter(VoteFilter voteFilter) {
    switch (voteFilter) {
      case VoteFilter.ALL:
        return 'ALL';
      case VoteFilter.MY_VOTES:
        return 'MY VOTES';
      case VoteFilter.MY_POOLS:
        return 'MY POOLS';
    }
  }

  String _convertPoolOrder(PoolOrder poolOrder) {
    switch (poolOrder) {
      case PoolOrder.NEW:
        return 'NEW';
      case PoolOrder.HOT:
        return 'HOT';
      case PoolOrder.CONTROVERSIAL:
        return 'CONTROVERSIAL';
    }
  }
}

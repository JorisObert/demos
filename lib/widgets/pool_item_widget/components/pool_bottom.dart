import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class PoolBottom extends StatefulWidget {
  PoolBottom({Key? key, required this.totalVotes, required this.poolId}) : super(key: key);

  final int totalVotes;
  final String poolId;

  @override
  State<PoolBottom> createState() => _PoolBottomState();
}

class _PoolBottomState extends State<PoolBottom> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${widget.totalVotes} ${widget.totalVotes > 1 ? 'votes' : 'vote'}',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13.0),),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.share, color: Colors.grey.shade400,),
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  constraints: BoxConstraints(),
                  onPressed: () {}),
              SizedBox(
                width: 16.0,
              ),
              PopupMenuButton<String>(
                onSelected: _handleClick,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade400,
                ),
                itemBuilder: (BuildContext context) {
                  return {'Report this pool'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleClick(String value) {
    switch (value) {
      case 'Report this pool':
        context.read<PoolProvider>().reportPool(
            poolId: widget.poolId,
            userId: context.read<DemosUserProvider>().user!.id!
        );
        break;
    }
  }
}



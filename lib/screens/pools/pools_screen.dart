import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/screens/main/main_screen.dart';
import 'package:demos/screens/pools/components/generic_pool_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoolsScreen extends StatefulWidget {
  final VoidCallback anonymousClick;
  final Stream<FilterChoiceId> stream;

  const PoolsScreen({Key? key, required this.anonymousClick, required this.stream}) : super(key: key);

  @override
  _PoolsScreenState createState() => _PoolsScreenState();
}

class _PoolsScreenState extends State<PoolsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericPoolList(stream: widget.stream,);
  }
}

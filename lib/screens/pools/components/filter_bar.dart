import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool _wantsOnlyMine = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _onlyMineCheckBox
      ],
    );
  }

  Widget get _onlyMineCheckBox{
    return Checkbox(value: _wantsOnlyMine, onChanged: (value){
      setState(() {
        _wantsOnlyMine = value!;
      });
      context.read<PoolProvider>().resetPoolList();
      context.read<PoolProvider>().getPools(lang: 'FR');
    });
  }
}

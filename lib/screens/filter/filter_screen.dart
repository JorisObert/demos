import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/src/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  int _distanceValue = 5;

  bool _isWorldWild = true;


  final VisualDensity _visualDensity = VisualDensity(
  horizontal: VisualDensity.minimumDensity,
  vertical: VisualDensity.minimumDensity,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
        ),
        body: Theme(
          data: ThemeData.light(),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.grey.shade900),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _poolOrderChoices(),
                  _votesFilterChoices(),
                  _poolStateChoices(),
                  _langChoice(),
                  _locationChoice(),
                  ElevatedButton(onPressed: (){
                    context.read<PoolProvider>().applyFilters();
                    Navigator.of(context).pop();
                  }, child: Text('apply filters'))
                ],
              ),
            ),
          ),
        ));
  }

  Widget _poolOrderChoices() {
    PoolOrder _poolOrder = context.select((PoolProvider p) => p.filters[POOL_ORDER_KEY]) ?? PoolOrder.NEW;
    return Wrap(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<PoolOrder>(
              visualDensity: _visualDensity,
              value: PoolOrder.NEW,
              groupValue: _poolOrder,
              onChanged: (poolOrder) {
                setState(() {
                  context.read<PoolProvider>().filters[POOL_ORDER_KEY]= poolOrder!;
                });
              },
            ),
            Text('NEW'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<PoolOrder>(
              visualDensity: _visualDensity,
              value: PoolOrder.HOT,
              groupValue: _poolOrder,
              onChanged: (poolOrder) {
                setState(() {
                  context.read<PoolProvider>().filters[POOL_ORDER_KEY]= poolOrder!;
                });
              },
            ),
            Text('HOT'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<PoolOrder>(
              visualDensity: _visualDensity,
              value: PoolOrder.CONTROVERSIAL,
              groupValue: _poolOrder,
              onChanged: (poolOrder) {
                setState(() {
                  context.read<PoolProvider>().filters[POOL_ORDER_KEY]= poolOrder!;
                });
              },
            ),
            Text('CONTROVERSIAL'),
          ],
        ),
      ],
    );
  }

  Widget _votesFilterChoices() {
    VoteFilter _voteFilter = context.select((PoolProvider p) => p.filters[VOTE_FILTER_KEY]) ?? VoteFilter.ALL;
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<VoteFilter>(
              visualDensity: _visualDensity,
              value: VoteFilter.ALL,
              groupValue: _voteFilter,
              onChanged: (voteFilter) {
                setState(() {
                  context.read<PoolProvider>().filters[VOTE_FILTER_KEY]= voteFilter!;
                });
              },
            ),
            Text('ALL VOTES'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<VoteFilter>(
              visualDensity: _visualDensity,
              value: VoteFilter.MY_VOTES,
              groupValue: _voteFilter,
              onChanged: (voteFilter) {
                setState(() {
                  context.read<PoolProvider>().filters[VOTE_FILTER_KEY]= voteFilter!;
                });
              },
            ),
            Text('MY VOTES'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<VoteFilter>(
              visualDensity: _visualDensity,
              value: VoteFilter.MY_POOLS,
              groupValue: _voteFilter,
              onChanged: (voteFilter) {
                setState(() {
                  context.read<PoolProvider>().filters[VOTE_FILTER_KEY]= voteFilter!;
                });
              },
            ),
            Text('MY POOLS'),
          ],
        ),
      ],
    );
  }

  Widget _poolStateChoices() {
    PoolState _poolState = context.select((PoolProvider p) => p.filters[POOL_STATE_KEY]) ?? PoolState.LIVE;
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<PoolState>(
              visualDensity: _visualDensity,
              value: PoolState.LIVE,
              groupValue: _poolState,
              onChanged: (poolState) {
                setState(() {
                  context.read<PoolProvider>().filters[POOL_STATE_KEY]= poolState;
                });
              },
            ),
            Text('LIVE'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<PoolState>(
              visualDensity: _visualDensity,
              value: PoolState.FINISHED,
              groupValue: _poolState,
              onChanged: (poolState) {
                setState(() {
                  context.read<PoolProvider>().filters[POOL_STATE_KEY]= poolState;
                });
              },
            ),
            Text('FINISHED'),
          ],
        )
      ],
    );
  }

  Widget _langChoice() {
    String? _langCode = context.select((PoolProvider p) => p.filters[COUNTRY_CODE_KEY]);
    return Row(
      children: [
        Icon(Icons.language),
        Switch(
          value: _isWorldWild,
          onChanged: (hasLang){
            print(hasLang);
            if(hasLang){

            }
            setState(() {
              _isWorldWild = hasLang;
            });
          },
        ),
        Flexible(
          child: LanguagePickerDropdown(
              itemBuilder: (language){
                return Text(_langCode ?? language.isoCode);
              },
              onValuePicked: (Language language) {
                setState(() {
                  context.read<PoolProvider>().filters[COUNTRY_CODE_KEY] = language.isoCode;
                });
              }),
        ),
      ],
    );
  }

  Widget _locationChoice() {
    return InkWell(
      onTap: (){
       //_showDistancePicker();
      },
      child: Row(
        children: [

          Text('Current value: '),
      DropdownButton<int>(
        value: _distanceValue,
        //icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        onChanged: (int? newValue) {
          setState(() {
            _distanceValue = newValue!;
          });
        },
        dropdownColor: Colors.grey,
        items: <int>[1, 5, 10, 20, 50, 100]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()+'km'),
          );
        }).toList(),
      )
        ],
      ),
    );
  }

}

const POOL_ORDER_KEY = 'pool_order';
const VOTE_FILTER_KEY = 'vote_filter';
const POOL_STATE_KEY = 'pool_state';
const LOCATION_KEY = 'location';
const COUNTRY_CODE_KEY = 'countryCode';
const HASHTAG_KEY = 'hashtag';
const USER_ID_KEY = 'userId';

enum PoolOrder { NEW, HOT, CONTROVERSIAL }
enum VoteFilter { ALL, MY_VOTES, MY_POOLS }
enum PoolState { LIVE, FINISHED }

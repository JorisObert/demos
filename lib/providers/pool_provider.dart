import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/services/api_calls.dart';
import 'package:flutter/cupertino.dart';

class PoolProvider extends ChangeNotifier {
  static List<Pool> _pools = [];
  List<Pool> get pools => _pools;

  static List<Pool> _userPools = [];
  List<Pool> get userPools => _userPools;

  static List<Pool> _userVotedPools = [];
  List<Pool> get userVotedPools => _userVotedPools;

  void resetPoolList(){
    _pools.clear();
  }

  Future<void> getPools({String? lang, required String userId}) async {
    print('getting pools');
      var newPools = await ApiCalls.getUnseenPools(lang: lang, userId: userId);
      print('results is $newPools');
      if (newPools != null) {
        _pools = List.from(_pools);
        for (Pool? pool in newPools) {
          await _getChoicesNbrVotes(pool!.choices!);
          _pools.add(pool);
        }
    }
    notifyListeners();
  }

  Future<void> getUserPools({bool finished = false, required String userId}) async {

    var newPools = await ApiCalls.getUserPools(finished: finished, userId: userId);
    print('results is $newPools');
    if (newPools != null) {
      _userPools = List.from(_userPools);
      for (Pool? pool in newPools) {
        await _getChoicesNbrVotes(pool!.choices!);
        _userPools.add(pool);
      }
    }
    notifyListeners();
  }

  Future<void> getUserVotedPools({bool finished = false, required String userId}) async {

    var newPools = await ApiCalls.getUserVotedPools(finished: finished, userId: userId);
    print('results is $newPools');
    if (newPools != null) {
      _userVotedPools = List.from(_userVotedPools);
      for (Pool? pool in newPools) {
        await _getChoicesNbrVotes(pool!.choices!);
        _userVotedPools.add(pool);
      }
    }
    notifyListeners();
  }

  _getChoicesNbrVotes(List<dynamic> choices) async{
    for(Choice choice in choices){
      print('nbr votes for ${choice.objectId} is ${await ApiCalls.getChoiceCount(choice)}');
      choice.nbrVotes = await ApiCalls.getChoiceCount(choice);
    }
  }

  Future<bool> createPool(Pool pool, List<Choice> choices) async {
    if(pool.ownerId == null) return false;
    bool success = await ApiCalls.createPool(pool, choices);
    if(success){
      /*pool.choices = choices;
      _pools = List.from(_pools);
      _pools.add(pool);
      notifyListeners();*/
    }
    return success;
  }

  Future<Vote?> saveVote(Choice choice, String? ownerId, String? poolId) async {
    if(ownerId == null || poolId == null) return null;
    Map<Vote?, int?>? result = await ApiCalls.saveUserVote(choice, ownerId, poolId);
    return result?.keys.first;
  }

  _incrementLocalPool(String poolId, Choice choice) {
    _pools = List.from(_pools);
    /*int? value = _pools
        .firstWhere((element) => element.objectId == poolId, orElse: null)
        .choices[choice.title];
    print(value);
    _pools
        .firstWhere((element) => element.objectId == poolId, orElse: null)
        .choices
        .update(choice.title, (value) => value + 1);*/
    _pools.add(_pools.last);
    _pools.remove(_pools.last);
    notifyListeners();
  }
}

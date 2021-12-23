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

  static List<Vote> _userVotes = [];
  List<Vote> get userVotes => _userVotes;

  void resetPoolList(){
    _pools.clear();
  }

  Future<void> getPools({String? lang,}) async {
    print('getting pools');
      var newPools = await ApiCalls.getPools(lang: lang,);
      print('results is $newPools');
      if (newPools != null) {
        _pools = List.from(_pools);
        for (Pool? pool in newPools) {
          _pools.add(pool!);
        }
    }
    notifyListeners();
  }

  Future<void> getUserPools({bool finished = false, required String userId}) async {

    var newPools = await ApiCalls.getUserPools(finished: finished, userId: userId);
    print('results is $newPools');
    if (newPools != null) {
      _pools = List.from(_pools);
      for (Pool? pool in newPools) {
        _pools.add(pool!);
      }
    }
    notifyListeners();
  }

  Future<bool> createPool(Pool pool, List<Choice> choices, BackendlessUser? user) async {
    if(user == null) return false;
    bool success = await ApiCalls.createPool(pool, choices, user.getUserId());
    if(success){
      pool.choices = choices;
      pool.user = user;
      _pools = List.from(_pools);
      _pools.add(pool);
      notifyListeners();
    }
    return success;
  }

  Future<Vote?> saveVote(Choice choice) async {
    Map<Vote?, int?>? result = await ApiCalls.saveUserVote(choice);
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

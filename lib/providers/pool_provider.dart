import 'package:collection/src/iterable_extensions.dart';
import 'package:demos/components/pool_item/components/pool_bar.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/user_vote.dart';
import 'package:demos/services/api_calls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PoolProvider extends ChangeNotifier {
  static List<Pool> _pools = [];
  List<Pool> get pools => _pools;

  static List<Pool> _userPools = [];
  List<Pool> get userPools => _userPools;

  static List<UserVote> _userVotes = [];
  List<UserVote> get userVotes => _userVotes;

  Future<void> getPools() async {

      var newPools = await ApiCalls.getPoolsByNewest(_userVotes);
      if (newPools != null) {
        _pools = List.from(_pools);
        for (Pool pool in newPools) {
          if (_userVotes
                  .firstWhereOrNull((element) => element.voteId == pool.id) ==
              null) {
            _pools.add(pool);
          }
        }

    }
    notifyListeners();
  }

  Future<void> getUserPools() async {
    print('getting user pools');
    var newPools = await ApiCalls.getUserPoolsByNewest(_userVotes);
    if (newPools != null) {
      _userPools = List.from(_userPools);
      _userPools.addAll(newPools);
      print('getting user pools 2 ${_userPools.length}');
    }
    notifyListeners();
  }

  Future<void> createPool(Pool pool) async {
    _pools = List.from(_pools);
    _pools.add(pool);
    notifyListeners();
    return await ApiCalls.createPool(pool);
  }

  Future<Pool?> getPoolById(String voteId) async {
    return await ApiCalls.getPoolById(voteId);
  }

  Future<List<UserVote>> getUserVotes() async {
    var newVotes = await ApiCalls.getUserVotes();
    _userVotes.addAll(newVotes);
    notifyListeners();
    return _userVotes;
  }

  Future<void> addVote(String poolId, Choice choice) async {
    var userVote = UserVote(choice.title, DateTime.now(),
        FirebaseAuth.instance.currentUser!.uid, poolId);
    _incrementLocalPool(poolId, choice);
    ApiCalls.recordUserVote(userVote);
    return await ApiCalls.addVote(userVote);
  }

  _incrementLocalPool(String poolId, Choice choice) {
    _pools = List.from(_pools);
    int? value = _pools
        .firstWhere((element) => element.id == poolId, orElse: null)
        .choices[choice.title];
    print(value);
    _pools
        .firstWhere((element) => element.id == poolId, orElse: null)
        .choices
        .update(choice.title, (value) => value + 1);
    _pools.add(_pools.last);
    _pools.remove(_pools.last);
    notifyListeners();
  }
}

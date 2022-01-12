import 'dart:convert';
import 'dart:developer';

import 'package:collection/src/iterable_extensions.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/demos_user.dart';
import 'package:demos/models/hashtag.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/screens/filter/filter_screen.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class PoolProvider extends ChangeNotifier {
  static List<Pool> _pools = [];
  List<Pool> get pools => _pools;

  static List<Pool> _userPools = [];
  List<Pool> get userPools => _userPools;

  static List<Pool> _userVotedPools = [];
  List<Pool> get userVotedPools => _userVotedPools;

  static Map<String, dynamic> _filters = {};
  Map<String, dynamic> get filters => _filters;

  static LoadingState _loadingState = LoadingState.DONE;
  LoadingState get loadingState => _loadingState;

  static String? _userId;

  void initFilters(){
    _filters[USER_ID_KEY] = _userId;
    _filters[POOL_STATE_KEY] = PoolState.LIVE;
    _filters[VOTE_FILTER_KEY] = VoteFilter.ALL;
    _filters[POOL_ORDER_KEY] = PoolOrder.NEW;
  }

  void setUserId({String? userId}){
    _userId = userId;
    _filters[USER_ID_KEY] = userId;
  }

  Future<void> applyFilters() async{
    _loadingState = LoadingState.LOADING;
    _resetPoolList();
    await getPools();
    _loadingState = LoadingState.DONE;
    notifyListeners();
  }

  Future<void> refreshPools() async{
    _loadingState = LoadingState.REFRESH;
    await getPools();
    _loadingState = LoadingState.DONE;
    notifyListeners();
  }

  Future<void> loadMore() async{
    _loadingState = LoadingState.LOAD_MORE;
    await getPools();
    _loadingState = LoadingState.DONE;
    notifyListeners();
  }

  void _resetPoolList() {
    _pools.clear();
  }

  Future<ApiResponse> getNewPools(String? countryCode, String? languageCode, String userId) async {

    return await ApiCalls.getNewPools(userId: userId,
       languageCode: languageCode,
       countryCode: countryCode);

  }

  Future<void> getPools() async {
    var newPools = await ApiCalls.getPools(filters: filters, offset: _pools.length);
    _pools = List.from(_pools);
    for (Pool pool in newPools) {
      _pools.add(pool);
    }
    if(newPools.isEmpty && _pools.lastOrNull?.id != POOL_EMPTY_ID){
      _pools.add(Pool(id: POOL_EMPTY_ID, userId: '', title: ''));
    }
  }

  Future<bool?> createPool(
      {required Pool pool, required List<Choice> choices, List<Hashtag>? hashtags = const []}) async {
    try {
      Pool poolResult = await ApiCalls.createPool(pool: pool, choices: choices, hashtags: hashtags);
      if(filters.containsKey(POOL_STATE_KEY) && filters[POOL_STATE_KEY] != PoolState.FINISHED){
        _pools = List.from(_pools);
        _pools.insert(0, poolResult);
      }
      notifyListeners();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<Vote?> saveVote(Choice choice, String? ownerId, String? poolId) async {
    if (ownerId == null || poolId == null) return null;
    _pools = List.from(_pools);
    Pool? pool = _pools.firstWhereOrNull((element) => element.id == poolId);
    if(pool != null){
      print('updating choices');
      List<Choice> choices = List.from(pool.choices!.toList());
      Choice userChoice = choices.firstWhere((element) => element.id == choice.id);
      userChoice.nbrVotes++;
      print(pool.toJson());
      notifyListeners();
    }
    bool result = await ApiCalls.saveUserVote(choice, ownerId);
    return null;
  }

  Future<bool> reportPool({required String poolId, required String userId}) async {
    return ApiCalls.reportPool(poolId, userId);
  }
}

enum LoadingState{LOADING, REFRESH, LOAD_MORE, DONE}

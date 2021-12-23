import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/vote.dart';
import 'package:flutter/cupertino.dart';

class ApiCalls {

  //User methods

  static Future<BackendlessUser?> loginUser(String login, String password){
    return Backendless.userService.login(login, password);
  }


  // Database methods

  static Future<bool> createPool(Pool pool, List<Choice> choices, BackendlessUser user) async {

    var poolResponse;

    //creating the pool
    try {
      poolResponse = await Backendless.data.withClass<Pool>().save(pool);
      Backendless.data.withClass<Pool>().setRelation(poolResponse!.objectId!, USER_FIELD,
          childrenObjectIds: [user.getUserId()]);
      debugPrint('pool created');
    } catch (e) {
      debugPrint('couldnt create pool: $e');
      return false;
    }

    for(Choice choice in choices){
      choice.poolId = poolResponse!.objectId!;
    }

    //create and set relations on choices
    try {
      var choiceResponse = await Backendless.data.withClass<Choice>().create(choices);
      Backendless.data.withClass<Pool>().setRelation(poolResponse!.objectId!, CHOICES_FIELD,
          childrenObjectIds: choiceResponse);
      return true;
    } catch (e) {
      debugPrint('couldnt create choices: $e');
      await Backendless.data.withClass<Pool>().remove(entity: poolResponse);
      return false;
    }
  }

  static Future<List<Pool?>?> getPools(
      {String? lang,}) async {
    try{
      DataQueryBuilder queryBuilder = DataQueryBuilder();
      queryBuilder.related = ['user', 'choices'];
      if(lang != null){
        queryBuilder.whereClause = "countryCode = '$lang'";
      }

      return Backendless.data.withClass<Pool>().find(queryBuilder);
    }catch(e){
      return null;
    }
  }

  static Future<List<Pool?>?> getUserPools(
      {bool finished = false, required userId}) async {
    try{
      print('getting pools $userId');
      DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "votes.ownerId = '$userId'";
      if(finished){
        queryBuilder.whereClause = "endDate < '${DateTime.now()}'";
      }
      return Backendless.data.withClass<Pool>().find(queryBuilder);
    }catch(e){
      print(e);
      return null;
    }
  }

  static Future<Map<Vote?, int?>?> saveUserVote(Choice choice) async {
    print(choice.objectId);
    Vote vote = Vote()..choiceId = choice.objectId;
    Vote? voteToDB = await Backendless.data.withClass<Vote>().save(vote);
    if(voteToDB != null){
      Backendless.data.withClass<Choice>().setRelation(choice.poolId!, VOTES_FIELD,
      childrenObjectIds: [voteToDB.objectId!]);
      int? count = await Backendless.counters.of(choice.objectId!).incrementAndGet();
      return {voteToDB: count};
    }
    return null;
  }

  static Future<int> getChoiceCount(Choice choice) async{
    return await Backendless.counters.of(choice.objectId!).getValue() ?? 0;
  }

  static const USER_FIELD = 'user';
  static const CHOICES_FIELD = 'choices';
  static const VOTES_FIELD = 'votes';

}

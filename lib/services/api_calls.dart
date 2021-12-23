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

  static Future<bool> createPool(Pool pool, List<Choice> choices) async {

    var poolResponse;

    //creating the pool
    try {
      poolResponse = await Backendless.data.withClass<Pool>().save(pool);
      Backendless.data.withClass<Pool>().setRelation(poolResponse!.objectId!, USER_ID_FIELD,
          childrenObjectIds: [poolResponse.ownerId!]);
      debugPrint('pool created');
    } catch (e) {
      debugPrint('couldnt create pool: $e');
      return false;
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

  static Future<List<Pool?>?> getUnseenPools(
      {String? lang, required String userId}) async {
    try{

      final unitOfWork = UnitOfWork();

      DataQueryBuilder queryBuilder = DataQueryBuilder();
      queryBuilder.related = ['user', 'choices', 'votes'];
      queryBuilder.whereClause = "votes.ownerId != '$userId' and ownerId != '$userId'";
      queryBuilder.properties = ['votes', 'Count(votes) as refs'];
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
      ..related = ['user', 'choices']
      ..whereClause = "ownerId = '$userId'";
      return Backendless.data.withClass<Pool>().find(queryBuilder);
    }catch(e){
      print(e);
      return null;
    }
  }

  static Future<List<Pool?>?> getUserVotedPools(
      {bool finished = false, required userId}) async {
    try{
      print('getting pools $userId');
      DataQueryBuilder queryBuilder = DataQueryBuilder()
        ..related = ['user', 'choices', 'votes']
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

  static Future<Map<Vote?, int?>?> saveUserVote(Choice choice, String ownerId, String poolId) async {
    print(choice.objectId);
    Vote vote = Vote()
      ..ownerId = ownerId;

    //vote to db
    Vote? voteToDB = await Backendless.data.withClass<Vote>().save(vote);
    if(voteToDB != null){

      //relation between vote to choiceId
      await Backendless.data.withClass<Vote>().setRelation(voteToDB.objectId!, CHOICE_ID_FIELD,
      childrenObjectIds: [choice.objectId!]);
      await Backendless.data.withClass<Pool>().setRelation(poolId, VOTES_FIELD,
          childrenObjectIds: [voteToDB.objectId!]);
      int? count = await Backendless.counters.of(choice.objectId!).incrementAndGet();
      return {voteToDB: count};
    }
    return null;
  }

  static Future<int> getChoiceCount(Choice choice) async{
    return await Backendless.counters.of(choice.objectId!).getValue() ?? 0;
  }

  static const USER_ID_FIELD = 'user';
  static const CHOICE_ID_FIELD = 'choice';
  static const CHOICES_FIELD = 'choices';
  static const VOTES_FIELD = 'votes';

}

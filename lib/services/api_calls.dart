import 'dart:developer';

import 'package:demos/models/choice.dart';
import 'package:demos/models/hashtag.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/pool_hashtag.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/screens/filter/filter_screen.dart';
import 'package:demos/services/graphql_requests_strings.dart';
import 'package:demos/services/token_interceptor.dart';
import 'package:demos/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:hasura_connect/hasura_connect.dart';

class ApiCalls {
  static String url = 'https://steady-bedbug-43.hasura.app/v1/graphql';
  static HasuraConnect hasuraConnect = HasuraConnect(
    url,
    interceptors: [TokenInterceptor()],
  );

  static bool _isGettingPools = false;

  static bool _hasCountryPools = true;

  static int offset = 0;

  // Database methods

  static Future<Pool> createPool(
      {required Pool pool, required List<Choice> choices, List<Hashtag>? hashtags}) async {
    print(hashtags);

    String addPoolMutation = '''
    mutation MyQuery(\$pool: pools_insert_input!, \$hashtags: [hashtags_insert_input!] = {}) {
      insert_pools_one(object: \$pool) {
        id
      }
      insert_hashtags(objects: \$hashtags, on_conflict: {constraint: hashtags_title_key}) {
        returning {
          id
        }
      }
    }
    ''';

    String addChoicesMutation = '''
    mutation addChoices(\$choices: [choices_insert_input!]!, \$poolHashtags: [pool_hashtag_insert_input!] = {}){
      insert_choices(objects: \$choices) {
        returning{
          id
        }
      }
      insert_pool_hashtag(objects: \$poolHashtags) {
        affected_rows
      }
    }
    ''';


    var addPoolResponse = await hasuraConnect.mutation(
      addPoolMutation,
      variables: {
        'pool': pool,
        'hashtags': hashtags,
      },
    ).onError((HasuraRequestError error, stackTrace) {
      print('error adding pool: $error');
    });

    print(addPoolResponse);

    String id = addPoolResponse['data']['insert_pools_one']['id'];
    List<dynamic> hashtagsIds =
      addPoolResponse['data']['insert_hashtags']['returning'].map((element)=> Hashtag.fromJson(element)).toList();

    print('we have id $id');
    for (Choice choice in choices) {
      choice.poolId = id;
      print(choice.toJson());
    }

    List<PoolHashtag> poolHashtags= [];
    for(Hashtag hashtag in hashtagsIds){
      print(hashtag.id);
      poolHashtags.add(PoolHashtag(poolId: id, hashtagId: hashtag.id));
    }

    var r2 = await hasuraConnect.mutation(
      addChoicesMutation,
      variables: {'choices': choices, 'poolHashtags': poolHashtags},
    ).onError((error, stackTrace) {
      print('error adding choices: $error');
    });
    print(r2);

    return pool
      ..id = id
      ..choices = choices;
  }



  static Future<ApiResponse> getNewPools(
      {String? countryCode, String? languageCode, required String userId})async{

    List<Pool> pools = [];
    if(_hasCountryPools){
      try {
        pools = await _getNewPoolsByCountry(countryCode, userId);
      } catch (e) {
        print('error getting new pools by country: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
      }
    }

    if(pools.length < POOL_REQUEST_LIMIT){
      _hasCountryPools = false;
      try {
        pools.addAll(await _getNewPoolsByLanguage(languageCode, userId));
      } on Exception catch (e) {
        print('error getting new pools by language: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
            errorMessage: e.toString());
      }
    }

    offset = offset + pools.length;

    return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
        data: pools);
  }

  static Future<List<Pool>> _getNewPoolsByCountry(String? countryCode, String userId) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getNewPoolsByCountryQuery,
        variables: {
          'countryCode': countryCode,
          'userId': userId,
          'offset': offset,
        })
        .onError((error, stackTrace) {
      print(error);
    });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<List<Pool>> _getNewPoolsByLanguage(String? languageCode, String userId) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getNewPoolsByLanguageQuery,
        variables: {
          'languageCode': languageCode,
          'userId': userId,
          'offset': offset,
        })
        .onError((error, stackTrace) {
      print(error);
    });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static List<Pool> _processPoolQueryResponse(dynamic queryResponse){
    if (queryResponse != null && queryResponse['data'] != null) {
      List<Pool> pools = (queryResponse['data']['pools'] as List)
          .map((e) => Pool.fromJson(e))
          .toList();
      _isGettingPools = false;
      return pools;
    }
    return [];
  }

  static Future<List<Pool>> getPools(
      {required Map<String, dynamic> filters, int offset = 0}) async {

    if(_isGettingPools) return [];

    _isGettingPools = true;



    String getPoolsQuery = '''
      query MyQuery
        (        
        ${_getCountryCodeParameterString(filters[COUNTRY_CODE_KEY])}
        ${_getHashtagParameterString(filters[HASHTAG_KEY])}  
        ${_getVoteFilterParameterString(filters[VOTE_FILTER_KEY] ?? VoteFilter.ALL)}        
        )    
       {
        pools(    
           limit: ${POOL_REQUEST_LIMIT}, offset: ${offset},      
           ${_getWhereQueryString(filters)}
           ${_getPoolOrderQueryString(filters[POOL_ORDER_KEY] ?? PoolOrder.NEW)}        
           ) {
              id
              title
              userId              
              choices(order_by: {id: asc}){
                title
                poolId
                id
                nbrVotes
              }
              user {
                displayName
                profilePicUrl                
              }
              votes(where: {userId: {_eq: \$userId}}) {
                choiceId
              }
              hashtags{
                hashtag{
                  id
                  title
                }
              }              
              }
}
    ''';

    var queryResponse = await hasuraConnect
        .query(getPoolsQuery, variables: _getVariablesMap(filters))
        .onError((error, stackTrace) {
      print(error);
    });

    if (queryResponse != null && queryResponse['data'] != null) {
      List<Pool> pools = (queryResponse['data']['pools'] as List)
          .map((e) => Pool.fromJson(e))
          .toList();
      _isGettingPools = false;
      return pools;
    }
    _isGettingPools = false;
    return [];
  }

  static Future<bool> saveUserVote(Choice choice, String userId) async {
    Vote vote =
        Vote(userId: userId, choiceId: choice.id, poolId: choice.poolId);

    String addVoteQuery = r'''
     mutation MyQuery($vote: votes_insert_input!, $choiceId: uuid!) {
     insert_votes_one(object: $vote){
        id
      }
      update_choices(where: {id: {_eq: $choiceId}}, _inc: {nbrVotes: 1}) {
        returning {
          nbrVotes
        }
      }
    }
    ''';

    var mutationResponse = await hasuraConnect.mutation(addVoteQuery,
        variables: {'vote': vote.toJson(), 'choiceId': choice.id});

    return true;
  }

  static Future<bool> reportPool(String poolId, String userId) async {

    print(poolId);
    print(userId);

    String addReportQuery = r'''
     mutation MyQuery($poolId: uuid!, $userId: String!) {
        insert_reports_one(object: {poolId: $poolId, userId: $userId}) {
          id
        }
      }
    ''';

    try {
      await hasuraConnect.mutation(addReportQuery,
          variables: {'poolId': poolId, 'userId': userId});
      debugPrint('Report sent');
      return true;
    } catch (e) {
      debugPrint('Error while adding report: $e');
      return false;
    }
  }

  static Future<int?> getChoiceCount(Choice choice) async {
    //return await Backendless.counters.of(choice.objectId!).getValue() ?? 0;
  }

  static String _getCountryCodeParameterString(String? countryCode) {
    return countryCode != null ? "\$countryCode: String!," : "";
  }

  static String _getCountryCodeQueryString(String? countryCode) {
    return countryCode != null
        ? ',_and: {countryCode: {_eq: \$countryCode}'
        : '';
  }

  static String _getHashtagParameterString(String? hashtag) {
    return hashtag != null ? "\$hashtag: String!," : '';
  }

  static String _getHashtagCodeQueryString(String? hashtag) {
    return hashtag != null ? ',_and: {hashtags: {title: {_in: \$hashtag}}' : '';
  }

  static String _getPoolOrderQueryString(PoolOrder poolOrder) {
    switch (poolOrder) {
      case PoolOrder.NEW:
        return "order_by: {createdAt: desc},";
      case PoolOrder.HOT:
        return "order_by: {votes_aggregate: {count: asc}},";
      case PoolOrder.CONTROVERSIAL:
        return "order_by: {choices_aggregate: {variance: {nbrVotes: asc}}},";
    }
  }

  static String _getVoteFilterParameterString(VoteFilter voteFilter) {
    return "\$userId: String!,";
  }

  static String _getVoteFilterQueryString(VoteFilter? voteFilter) {
    if(voteFilter == null)return '';
    switch (voteFilter) {
      case VoteFilter.ALL:
        return '';
      case VoteFilter.MY_VOTES:
        return ',_and: {votes: {userId: {_eq: \$userId}}';
      case VoteFilter.MY_POOLS:
        return ',_and: {userId: {_eq: \$userId}';
    }
  }

  static String _getPoolStateQueryString(PoolState poolState) {
    switch (poolState) {
      case PoolState.LIVE:
        return 'where: {endDate: {_gt: "now()"}';
      case PoolState.FINISHED:
        return 'where: {endDate: {_lte: "now()"}';
    }
    ;
  }

  static String _getNonHiddenQueryString() {
        return ', isHidden: {_eq: false}';
  }

  static String _getUserVoteQueryString() {
    return 'votes(where: {userId: {_eq: \$userId}}) {choiceId}';
  }

  static String _getWhereQueryString(Map<String, dynamic> filters) {
    String whereQuery = _getPoolStateQueryString(
            filters[POOL_STATE_KEY] ?? PoolState.LIVE) + _getNonHiddenQueryString();

    String endQuery = '}';

    if(_getCountryCodeQueryString(filters[COUNTRY_CODE_KEY]).isNotEmpty){
      whereQuery = whereQuery + _getCountryCodeQueryString(filters[COUNTRY_CODE_KEY]);
      endQuery = endQuery + '}';
    }

    if(_getHashtagCodeQueryString(filters[HASHTAG_KEY]).isNotEmpty){
      whereQuery = whereQuery + _getHashtagCodeQueryString(filters[HASHTAG_KEY]);
      endQuery = endQuery + '}';
    }

    if(_getVoteFilterQueryString(filters[VOTE_FILTER_KEY]).isNotEmpty){
      whereQuery = whereQuery + _getVoteFilterQueryString(filters[VOTE_FILTER_KEY]);
      endQuery = endQuery + '}';
    }

    whereQuery = whereQuery + endQuery;
    print(whereQuery);
    return whereQuery;
  }

  static Map<String, dynamic> _getVariablesMap(Map<String, dynamic> map) {
    Map<String, dynamic> variables = {};
    if(map.containsKey(COUNTRY_CODE_KEY) && map[COUNTRY_CODE_KEY] != null){
      variables[COUNTRY_CODE_KEY] = map[COUNTRY_CODE_KEY];
    }
    if(map.containsKey(HASHTAG_KEY) && map[HASHTAG_KEY] != null){
      variables[HASHTAG_KEY] = map[HASHTAG_KEY];
    }

    variables[USER_ID_KEY] = map[USER_ID_KEY];

    print('variables are $variables');
    return variables;
  }

  static const USER_ID_FIELD = 'user';
  static const CHOICE_ID_FIELD = 'choice';
  static const CHOICES_FIELD = 'choices';
  static const VOTES_FIELD = 'votes';
}

class ApiResponse{
  final ApiResponseStatus apiResponseStatus;
  final dynamic data;
  final String? errorMessage;

  ApiResponse({required this.apiResponseStatus, this.data, this.errorMessage});

}

enum ApiResponseStatus{SUCCESS, ERROR}

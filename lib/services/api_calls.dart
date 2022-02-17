
import 'package:demos/models/choice.dart';
import 'package:demos/models/hashtag.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/pool_hashtag.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/services/graphql_requests_strings.dart';
import 'package:demos/services/token_interceptor.dart';
import 'package:demos/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopoint/geopoint.dart';
import 'package:hasura_connect/hasura_connect.dart';

class ApiCalls {
  static String url = 'https://steady-bedbug-43.hasura.app/v1/graphql';
  static HasuraConnect hasuraConnect = HasuraConnect(
    url,
    interceptors: [TokenInterceptor()],
  );

  static bool _isGettingPools = false;

  // Database methods

  static Future<Pool> createPool(
      {required Pool pool, required List<Choice> choices, List<Hashtag>? hashtags}) async {

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

    for (Choice choice in choices) {
      choice.poolId = id;
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
      {String? countryCode, String? languageCode, String? userId, required int offset})async{

    List<Pool> pools = [];
    if(countryCode != null){
      try {
        pools = await _getNewPoolsByCountry(countryCode: countryCode, userId: userId, offset: offset);
      } catch (e) {
        print('error getting new pools by country: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
      }
    }

    if(pools.length < POOL_REQUEST_LIMIT && languageCode != null){
      try {
        pools.addAll(await _getNewPoolsByLanguage(languageCode: languageCode, userId: userId, offset: offset));
      } on Exception catch (e) {
        print('error getting new pools by language: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
            errorMessage: e.toString());
      }
    }

    if(pools.length < POOL_REQUEST_LIMIT){
      try {
        pools.addAll(await _getNewPoolsNoFilter(userId: userId, offset: offset));
      } on Exception catch (e) {
        print('error getting new pools by language: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
            errorMessage: e.toString());
      }
    }

    return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
        data: pools);
  }

  static Future<List<Pool>> _getNewPoolsByCountry(
      {required String countryCode, String? userId, required int offset}) async{
    if(_isGettingPools) return [];

    print('getting new by country with code: $countryCode');

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getNewPoolsByCountryQuery,
        variables: {
          'countryCode': countryCode.toLowerCase(),
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    print('getting new pools by country response is $queryResponse');

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<List<Pool>> _getNewPoolsByLanguage(
      {required String languageCode, String? userId, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    print('getting new by language with code: $languageCode');

    var queryResponse = await hasuraConnect
        .query(getNewPoolsByLanguageQuery,
        variables: {
          'languageCode': languageCode.toLowerCase(),
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });



    print('getting new pools by language response is $queryResponse');

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<List<Pool>> _getNewPoolsNoFilter(
      {String? userId, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;


    var queryResponse = await hasuraConnect
        .query(getNewPoolsNoFilterQuery,
        variables: {
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<ApiResponse> getHotPools(
      {String? countryCode, String? languageCode, String? userId, required int offset})async{

    List<Pool> pools = [];
    if(countryCode != null){
      try {
        pools = await _getHotPoolsByCountry(countryCode: countryCode, userId: userId, offset: offset);
      } catch (e) {
        print('error getting hot pools by country: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
            errorMessage: e.toString());
      }
    }

    if(pools.length < POOL_REQUEST_LIMIT && languageCode != null){
      try {
        pools.addAll(await _getHotPoolsByLanguage(languageCode: languageCode, userId: userId, offset: offset));
      } on Exception catch (e) {
        print('error getting hot pools by language: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
            errorMessage: e.toString());
      }
    }

    if(pools.length < POOL_REQUEST_LIMIT){
      try {
        pools.addAll(await _getHotPoolsNoFilter(userId: userId, offset: offset));
      } on Exception catch (e) {
        print('error getting hot pools by language: $e');
        return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
            errorMessage: e.toString());
      }
    }

    return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
        data: pools);
  }

  static Future<List<Pool>> _getHotPoolsByCountry(
      {required String countryCode, String? userId, required int offset}) async{
    if(_isGettingPools) return [];

    print('getting new by country with code: $countryCode');

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getNewPoolsByCountryQuery,
        variables: {
          'countryCode': countryCode.toLowerCase(),
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    print('getting new pools by country response is $queryResponse');

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<List<Pool>> _getHotPoolsByLanguage(
      {required String languageCode, String? userId, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    print('getting new by language with code: $languageCode');

    var queryResponse = await hasuraConnect
        .query(getNewPoolsByLanguageQuery,
        variables: {
          'languageCode': languageCode.toLowerCase(),
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });



    print('getting new pools by language response is $queryResponse');

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<List<Pool>> _getHotPoolsNoFilter(
      {String? userId, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;


    var queryResponse = await hasuraConnect
        .query(getNewPoolsNoFilterQuery,
        variables: {
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse).reversed.toList();
  }

  static Future<ApiResponse> getMyPools({required String userId, required int offset}) async{

    try {
      var pools = await _getPoolsByUserId(userId: userId, offset: offset);

      return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
          data: pools);
    } catch (e) {
      print('error getting my pools: $e');
      return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
    }

  }

  static Future<List<Pool>> _getPoolsByUserId({required String userId, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getMyPoolsQueryString,
        variables: {
          'userId': userId,
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<ApiResponse> getMyVotes({required String userId, required int offset}) async{

    try {
      var pools = await _getVotesByUserId(userId: userId, offset: offset);

      return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
          data: pools);
    } catch (e) {
      print('error getting my votes: $e');
      return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
    }

  }

  static Future<List<Pool>> _getVotesByUserId({required String userId, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getMyVotesQueryString,
        variables: {
          'userId': userId,
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    _isGettingPools = false;

    return _processVotesQueryResponse(queryResponse);
  }

  static Future<ApiResponse> getGenericPoolSearch({String? userId, required String search, required int offset}) async{

    try {
      var pools = await _getSearchByGenericTerms(userId: userId, search: search, offset: offset);
      return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
          data: pools);
    } catch (e) {
      print('error getting my votes: $e');
      return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
    }

  }

  static Future<List<Pool>> _getSearchByGenericTerms(
      {String? userId, required String search, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getSearchString,
        variables: {
          'search': '%$search%',
          'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<ApiResponse> getClosestPools({String? userId, required Map<String, dynamic>? geoPoint, required offset}) async{

    try {
      var pools = await _getPoolsByLocation(userId: userId, offset: offset, geoPoint: geoPoint);
      return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
          data: pools);
    } catch (e) {
      print('error getting location pools: $e');
      return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
    }

  }

  static Future<List<Pool>> _getPoolsByLocation(
      {String? userId, required Map<String, dynamic>? geoPoint, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getClosestPoolsQuery,
        variables: {
          'from': geoPoint,
          //'userId': userId ?? '',
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
        });

    _isGettingPools = false;

    return _processPoolQueryResponse(queryResponse);
  }

  static Future<ApiResponse> getHashtagPools({String? userId, required String hashtag, required offset}) async{

    try {
      var pools = await _getSearchByHashtag(userId: userId, hashtag: hashtag, offset: offset);
      return ApiResponse(apiResponseStatus: ApiResponseStatus.SUCCESS,
          data: pools);
    } catch (e) {
      print('error getting hashtags pools: $e');
      return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR,
          errorMessage: e.toString());
    }

  }

  static Future<List<Pool>> _getSearchByHashtag(
      {String? userId, required String hashtag, required offset}) async{
    if(_isGettingPools) return [];

    _isGettingPools = true;

    var queryResponse = await hasuraConnect
        .query(getPoolsByHashtagQuery,
        variables: {
          'hashtag': hashtag,
          'userId': userId,
          'offset': offset,
          'limit': POOL_REQUEST_LIMIT,
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
      return pools.reversed.toList();
    }
    return [];
  }

  static List<Pool> _processVotesQueryResponse(dynamic queryResponse){
    if (queryResponse != null && queryResponse['data'] != null) {
      List<Pool> pools = (queryResponse['data']['votes'] as List)
          .map((e) => Pool.fromJson(e['pool']))
          .toList();
      _isGettingPools = false;
      return pools.reversed.toList();
    }
    return [];
  }

  static Future<bool> saveUserVote(Choice choice, String userId) async {
    Vote vote =
        Vote(userId: userId, choiceId: choice.id, poolId: choice.poolId);

    String addVoteQuery = r'''
     mutation MyQuery($vote: votes_insert_input!) {
     insert_votes_one(object: $vote){
        id
      }
    }
    ''';

    var mutationResponse = await hasuraConnect.mutation(addVoteQuery,
        variables: {'vote': vote.toJson()});

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

}

class ApiResponse{
  final ApiResponseStatus apiResponseStatus;
  final dynamic data;
  final String? errorMessage;

  ApiResponse({required this.apiResponseStatus, this.data, this.errorMessage});

  @override
  String toString()=>'ApiResponse: {${apiResponseStatus.toString()}, $data, $errorMessage';

}

enum ApiResponseStatus{SUCCESS, ERROR}

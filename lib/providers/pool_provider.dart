
import 'package:demos/models/choice.dart';
import 'package:demos/models/hashtag.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/services/api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';

class PoolProvider extends ChangeNotifier {

  static Map<String, dynamic>? _geoPoint;
  static DateTime? _lastPositionUpdate;


  Future<ApiResponse> getNewPools(
      {String? countryCode, String? languageCode, String? loggedUserId, required int offset}) async {

    return await ApiCalls.getNewPools(userId: loggedUserId,
       languageCode: languageCode,
       countryCode: countryCode,
       offset: offset);

  }

  Future<ApiResponse> getHotPools(
      {String? countryCode, String? languageCode, String? loggedUserId, required int offset}) async {

    return await ApiCalls.getHotPools(userId: loggedUserId,
        languageCode: languageCode,
        countryCode: countryCode,
        offset: offset);

  }

  Future<ApiResponse> getUserPools({required String loggedUserId, required int offset}) async {
    return await ApiCalls.getMyPools(userId: loggedUserId,
  offset: offset);
  }

  Future<ApiResponse> getMyVotes(
      {required String loggedUserId, required int offset}) async {
    return await ApiCalls.getMyVotes(userId: loggedUserId,
  offset: offset);
  }

  Future<ApiResponse> getPoolsByHashtag({String? userId, required String hashtag, required int offset}) async {
    print('getting pools by hashtags $hashtag');
    return await ApiCalls.getHashtagPools(hashtag: hashtag, userId: userId,
        offset: offset);
  }

  Future<ApiResponse> getPoolsByGenericSearch({String? userId, required String searchTerms, required int offset}) async {
    return await ApiCalls.getGenericPoolSearch(userId: userId, search: searchTerms,
        offset: offset);
  }

  Future<ApiResponse> getPoolsByLocation({String? userId, required int offset}) async {
    if(_geoPoint == null){
      return ApiResponse(apiResponseStatus: ApiResponseStatus.ERROR);
    }
    print('getting pools by location');
    return await ApiCalls.getClosestPools(userId: userId, offset: offset, geoPoint: _geoPoint!);
  }

  Future<bool?> createPool(
      {required Pool pool, required List<Choice> choices, List<Hashtag>? hashtags = const []}) async {
    try {
      Pool poolResult = await ApiCalls.createPool(pool: pool, choices: choices, hashtags: hashtags);
      /*if(filters.containsKey(POOL_STATE_KEY) && filters[POOL_STATE_KEY] != PoolState.FINISHED){
        _pools = List.from(_pools);
        _pools.insert(0, poolResult);
      }*/
      notifyListeners();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<Vote?> saveVote(Choice choice, String userId) async {

    bool result = await ApiCalls.saveUserVote(choice, userId);
    return null;
  }

  Future<bool> reportPool({required String poolId, required String userId}) async {
    return ApiCalls.reportPool(poolId, userId);
  }

  Future<Map<String, dynamic>?> getPosition() async {

    if(_geoPoint != null
        && (_lastPositionUpdate?.difference(DateTime.now()) ?? Duration(minutes: 60)) < Duration(minutes: 15)){
      return _geoPoint;
    }
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var position = await Geolocator.getCurrentPosition();

    _geoPoint = {
      "type": "Point",
      "coordinates": [position.latitude,position.longitude]
    };
    _lastPositionUpdate = DateTime.now();
    return _geoPoint;
  }
}

enum LoadingState{LOADING, REFRESH, LOAD_MORE, DONE}

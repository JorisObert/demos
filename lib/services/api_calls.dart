import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demos/components/pool_item/components/pool_bar.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/models/user_record.dart';
import 'package:demos/models/user_vote.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiCalls {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference demosUsers =
      FirebaseFirestore.instance.collection(DEMOS_USER_COLLECTION);
  static CollectionReference pools =
      FirebaseFirestore.instance.collection(POOLS_COLLECTION);

  static DocumentSnapshot? _lastPoolSnapshot;

  static DocumentSnapshot? _lastUserPoolSnapshot;

  static Future<List<Pool>?> getPoolsByNewest(
      List<UserVote> votesFilter) async {
    await FirebaseAuth.instance.signInAnonymously();

    Query query = pools;

    if(votesFilter.isNotEmpty){
      query = query.where(FieldPath.documentId, whereNotIn: votesFilter.map((e) => e.voteId).toList());
    }
    
    query = query.where('countryCode', isEqualTo: 'FR');

    if (_lastPoolSnapshot != null) {
      query = query.startAfterDocument(_lastPoolSnapshot!);
    }

    var snapshot = await query.limit(2).get();

    if(snapshot.docs.isNotEmpty){
      _lastPoolSnapshot = snapshot.docs.last;
    }

    return snapshot.docs
        .map((e) => Pool.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Pool>?> getUserPoolsByNewest(
      List<UserVote> votesFilter) async {
    await FirebaseAuth.instance.signInAnonymously();

    Query query = pools;

    if(votesFilter.isNotEmpty){
      query = query.where(FieldPath.documentId, whereIn: votesFilter.map((e) => e.voteId).toList());
    }

    if (_lastUserPoolSnapshot != null) {
      query = query.startAfterDocument(_lastUserPoolSnapshot!);
    }

    var snapshot = await query.limit(2).get();

    if(snapshot.docs.isNotEmpty){
      _lastUserPoolSnapshot = snapshot.docs.last;
    }

    return snapshot.docs
        .map((e) => Pool.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<void> createPool(Pool pool) async {
    var docRef = pools.doc();
    pool.id = docRef.id;
    return await docRef.set(pool.toJson());
  }

  static Future<List<UserVote>> getUserVotes() async {
    final snapshot = await demosUsers
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(VOTES_COLLECTION)
        .get();

    List<UserVote> userVote = [];
    for (var doc in snapshot.docs) {
      UserRecord userRecord = UserRecord.fromJson(doc.data());
      userVote.addAll(userRecord.vote);
    }

    print('populated list ${userVote.toString()}');

    return userVote;
  }

  static Future<Pool?> getPoolById(String voteId) async {
    final snapshot =
        await pools.where(POOL_ID_FIELD, isEqualTo: voteId).limit(1).get();
    return snapshot.docs.isNotEmpty
        ? Pool.fromJson(snapshot.docs.first.data() as Map<String, dynamic>)
        : null;
  }

  static Future<void> addVote(UserVote userVote) async {
    return await pools
        .doc(userVote.voteId)
        .update({'choices.${userVote.choice}': FieldValue.increment(1)});
  }

  static Future<void> recordUserVote(UserVote userVote) async {
    print(
        'were saving, hasIndex ? $_hasRecordIndex and index is $_lastRecordIndex');
    String indexDocId = await _getRecordMapIndex();
    return await demosUsers
        .doc(userVote.userId)
        .collection(VOTES_COLLECTION)
        .doc(indexDocId)
        .set({
      LAST_UPDATED_FIELD: userVote.date,
      VOTE_FIELD: {'${userVote.voteId}': jsonEncode(userVote.toJson())}
    }, SetOptions(merge: true));
  }

  static var _lastRecordIndex = 0;
  static bool _hasRecordIndex = false;

  static Future<String> _getRecordMapIndex() async {
    if (_hasRecordIndex) return _lastRecordIndex.toString();
    var snapshot = await demosUsers
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(VOTES_COLLECTION) /*
        .orderBy(LAST_UPDATED_FIELD)*/
        .limit(1)
        .get();

    print(snapshot.size);

    if (snapshot.size > 0) {
      print('weeeee');
      print(snapshot.docs.first.data().length);
      if (snapshot.docs.first.data().length > 100) {
        _lastRecordIndex = int.parse(snapshot.docs.first.id) + 1;
      } else {
        _lastRecordIndex = int.parse(snapshot.docs.first.id);
      }
    }

    _hasRecordIndex = true;

    return _lastRecordIndex.toString();
  }

  static Future<void> removeVote(String voteId, Choice choice) async {
    pools
        .doc(voteId)
        .collection(VOTES_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    return await pools
        .doc(voteId)
        .update({'choices.${choice.title}': FieldValue.increment(-1)});
  }

  static Future<UserVote?> userChoice(String voteId) async {
    final snapshot = await pools
        .doc(voteId)
        .collection(VOTES_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return UserVote.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  static const String DEMOS_USER_COLLECTION = "demos_users";
  static const String POOLS_COLLECTION = "pools";
  static const String VOTES_COLLECTION = "votes";
  static const String CHOICES_FIELD = "choices";
  static const String CHOICE_FIELD = "choice";
  static const String USERID_FIELD = "userId";
  static const String POOL_ID_FIELD = "voteId";
  static const String VOTE_FIELD = "vote";
  static const String DATE_FIELD = "date";
  static const String END_DATE_FIELD = "endDate";
  static const String LAST_UPDATED_FIELD = "last_updated";
}

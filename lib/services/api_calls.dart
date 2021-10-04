import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/models/vote_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ApiCalls{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference voteUsers = FirebaseFirestore.instance.collection(USER_COLLECTION);
  static CollectionReference votes = FirebaseFirestore.instance.collection(VOTES_COLLECTION);

  static Future<VoteUser?> getUser() async {
    return null;
  }

  static Future<List<Vote>?> getVotes() async {
    await FirebaseAuth.instance.signInAnonymously();
    var snapshot = await votes.get();
    print('getting snapshot: ${snapshot.docs}');
    return snapshot.docs.map((e) => Vote.fromJson(e.data() as Map<String, dynamic>)).toList();
  }

  static const String VOTES_COLLECTION = "votes";
  static const String USER_COLLECTION = "vote_users";

}
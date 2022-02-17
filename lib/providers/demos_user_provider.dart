
import 'package:cloud_functions/cloud_functions.dart';
import 'package:demos/models/demos_user.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/services/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DemosUserProvider extends ChangeNotifier {

  static User? _firebaseUser = FirebaseAuth.instance.currentUser;
  User? get firebaseUser => _firebaseUser;

  static DemosUser? _user = !(_firebaseUser?.isAnonymous ?? true) ? DemosUser(
    id: _firebaseUser!.uid,
    displayName: _firebaseUser!.displayName,
    profilePicUrl: _firebaseUser!.providerData.first.photoURL
  ):null;

  DemosUser? get user => _user;

  AuthStatus get authStatus => (_firebaseUser?.isAnonymous ?? true) ? AuthStatus.ANONYMOUS:AuthStatus.LOGGED;

  bool get isLoggedIn => !(_firebaseUser?.isAnonymous ?? true);

  FirebaseFunctions functions = FirebaseFunctions.instance;


  Future<User?> loginUser({required LoginProvider loginProvider})async {

    UserCredential? userCredential;
    switch(loginProvider){
      case LoginProvider.GOOGLE:
        userCredential = await SocialLogin.signInWithGoogle();
        break;
      case LoginProvider.APPLE:
        userCredential = await SocialLogin.signInWithApple();
        break;
      case LoginProvider.TWITTER:
        userCredential = await SocialLogin.signInWithTwitter();
        break;
      case LoginProvider.FACEBOOK:
        userCredential = await SocialLogin.signInWithFacebook();
        break;
    }

    _firebaseUser = userCredential.user;

    notifyListeners();

    return _firebaseUser;

  }

  Future<HttpsCallableResult?> setUpCustomClaims() async{
    if(_firebaseUser != null){
      print('method started');
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('setUserClaims');
      var result = await callable.call({'uid':_firebaseUser!.uid});
      print('method terminate');
      return result;
    }else{
      print('user is null, cannot set claims !');
    }

  }

  Future<HttpsCallableResult?> verifyAuth() async{
    if(_firebaseUser != null){
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('verifyAuth');
      var result = await callable.call({'token':await _firebaseUser!.getIdToken()});
      print('method terminate $result');
      return result;
    }else{
      print('user is null, cannot set claims !');
    }

  }

  Future<void> logoutUser() async{
    await FirebaseAuth.instance.signOut();
  }

}

enum LoginProvider{GOOGLE, APPLE, TWITTER, FACEBOOK}

enum AuthStatus{ANONYMOUS, LOGGED}
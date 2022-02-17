import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hasura_connect/hasura_connect.dart';

class TokenInterceptor extends InterceptorBase {

  TokenInterceptor();

  @override
  Future? onRequest(Request request, HasuraConnect connect) async{
    var user = await FirebaseAuth.instance.currentUser;

    if(user != null){
      var token = await user.getIdTokenResult();
      if((token.expirationTime ?? DateTime.now().add(Duration(seconds: 10))).isBefore(DateTime.now())){
        print('token is expired, refresh');
        token = await user.getIdTokenResult(true);
      }

      try {
        print('we have client');
        request.headers["Authorization"] = "Bearer ${token.token}";

        return request;
      } catch (e) {
        print('error in token inter $e');
        return null;
      }
    }else{
      try {
        return request;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

}
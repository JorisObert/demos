import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:demos/services/api_calls.dart';
import 'package:flutter/foundation.dart';

class DemosUserProvider extends ChangeNotifier {

  BackendlessUser? _user;
  BackendlessUser? get user => _user;

  loginUser()async {
    await Backendless.userService.logout();
    if(await Backendless.userService.isValidLogin() ?? false){

      _user = await Backendless.userService.getCurrentUser();
      print('user is valid from previous sessions ${_user!.email}');
    }else{
      print('we log in user');
      _user = await ApiCalls.loginUser('truc@truc.Fr', '12345');
    }

  }


}
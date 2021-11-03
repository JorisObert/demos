import 'package:demos/models/demos_user.dart';
import 'package:flutter/foundation.dart';

class DemosUserProvider extends ChangeNotifier {

  static DemosUser? _user;
  DemosUser? get user => _user;

}
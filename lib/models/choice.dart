import 'package:backendless_sdk/backendless_sdk.dart';

import 'pool.dart';

@reflector
class Choice {
  String? objectId;
  String? ownerId;
  late String title;
  Pool? pool;
  late int nbrVotes = 0;
}
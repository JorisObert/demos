import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:demos/models/choice.dart';


@reflector
class Vote {
  String? objectId;
  String? ownerId;
  Choice? choice;
}

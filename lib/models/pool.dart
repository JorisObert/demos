import 'package:backendless_sdk/backendless_sdk.dart';

@reflector
class Pool {
  String? objectId;
  String? title;
  BackendlessUser? user;
  List<dynamic>? choices;

  //final List<String>? hashtags;

  String? countryCode;

  bool isPrivate = false;

  int alert = 0;

  bool hidden = false;

  DateTime? endDate;


  @override
  String toString() {
    return '{${this.title}, ${this.countryCode}, ${this.isPrivate}, ${this.alert}, ${this.hidden}, ${this.endDate}, ${this.choices}';
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'demos_user.g.dart';

@JsonSerializable()
class DemosUser{

   final String? profilePicURL;
   final String name;
   final String? countryCode;

  DemosUser({this.countryCode, this.profilePicURL, required this.name});

   factory DemosUser.fromJson(Map<String, dynamic> json) =>
       _$DemosUserFromJson(json);
   Map<String, dynamic> toJson() => _$DemosUserToJson(this);
}
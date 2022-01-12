import 'package:json_annotation/json_annotation.dart';

part 'demos_user.g.dart';

@JsonSerializable(explicitToJson: true)
class DemosUser {

  final String? id;

  final String? email;

  final String? displayName;

  final String? profilePicUrl;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? createdAt;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? updatedAt;

  DemosUser({this.id, this.email, this.displayName, this.profilePicUrl,this.createdAt,
    this.updatedAt,});

  factory DemosUser.fromJson( Map<String, dynamic> json) => _$DemosUserFromJson(json);
  Map<String, dynamic> toJson() => _$DemosUserToJson(this);
}
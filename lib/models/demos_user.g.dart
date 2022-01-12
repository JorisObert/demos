// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demos_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemosUser _$DemosUserFromJson(Map<String, dynamic> json) => DemosUser(
      id: json['id'] as String?,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      profilePicUrl: json['profilePicUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DemosUserToJson(DemosUser instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'email': instance.email,
    'displayName': instance.displayName,
    'profilePicUrl': instance.profilePicUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  return val;
}

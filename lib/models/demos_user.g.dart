// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demos_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemosUser _$DemosUserFromJson(Map<String, dynamic> json) => DemosUser(
      countryCode: json['countryCode'] as String?,
      profilePicURL: json['profilePicURL'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$DemosUserToJson(DemosUser instance) => <String, dynamic>{
      'profilePicURL': instance.profilePicURL,
      'name': instance.name,
      'countryCode': instance.countryCode,
    };

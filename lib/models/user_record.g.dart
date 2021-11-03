// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRecord _$UserRecordFromJson(Map<String, dynamic> json) => UserRecord(
      dateTimeFromTimestamp(json['last_updated'] as Timestamp),
      UserRecord._mapToList(json['vote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRecordToJson(UserRecord instance) =>
    <String, dynamic>{
      'last_updated': dateTimeToTimestamp(instance.lastUpdated),
      'vote': instance.vote,
    };

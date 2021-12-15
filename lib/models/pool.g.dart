// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pool _$PoolFromJson(Map<String, dynamic> json) => Pool(
      identifier: json['identifier'] as String?,
      title: json['title'] as String,
      choices: Map<String, int>.from(json['choices'] as Map),
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      countryCode: json['countryCode'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      alert: json['alert'] as int? ?? 0,
      hidden: json['hidden'] as bool? ?? false,
      endDate: dateTimeFromTimestamp(json['endDate'] as Timestamp?),
      creator: decodeDemosUserFromJson(json['creator'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$PoolToJson(Pool instance) => <String, dynamic>{
      'id': instance.id,
      'identifier': instance.identifier,
      'title': instance.title,
      'choices': instance.choices,
      'creator': encodeDemosUserToJson(instance.creator),
      'hashtags': instance.hashtags,
      'countryCode': instance.countryCode,
      'isPrivate': instance.isPrivate,
      'alert': instance.alert,
      'hidden': instance.hidden,
      'endDate': dateTimeToTimestamp(instance.endDate),
    };

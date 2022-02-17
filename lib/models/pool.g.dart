// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pool _$PoolFromJson(Map<String, dynamic> json) => Pool(
      title: json['title'] as String,
      id: json['id'] as String?,
      userId: json['userId'] as String,
      user: json['user'] == null
          ? null
          : DemosUser.fromJson(json['user'] as Map<String, dynamic>),
      choices: (json['choices'] as List<dynamic>?)
          ?.map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
      votes: (json['votes'] as List<dynamic>?)
          ?.map((e) => Vote.fromJson(e as Map<String, dynamic>))
          .toList(),
      countryCode: json['countryCode'] as String? ?? 'us',
      languageCode: json['languageCode'] as String? ?? 'en',
      endDate: Pool._fromJson(json['endDate'] as int?),
      isPrivate: json['isPrivate'] as bool? ?? false,
      alert: json['alert'] as int? ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      hashtags: Pool._decodeHashtags(json['hashtags']),
      location: json['location'] as Map<String, dynamic>?,
      isHidden: json['isHidden'] as bool? ?? false,
      moderated: json['moderated'] as bool? ?? false,
    );

Map<String, dynamic> _$PoolToJson(Pool instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  writeNotNull('choices', Pool._nullableToJson(instance.choices));
  writeNotNull('votes', Pool._nullableToJson(instance.votes));
  writeNotNull('user', Pool._nullableToJson(instance.user));
  writeNotNull('hashtags', instance.hashtags?.map((e) => e.toJson()).toList());
  val['countryCode'] = instance.countryCode;
  val['languageCode'] = instance.languageCode;
  val['isPrivate'] = instance.isPrivate;
  val['alert'] = instance.alert;
  val['isHidden'] = instance.isHidden;
  val['endDate'] = Pool._toJson(instance.endDate);
  writeNotNull('createdAt', Pool._toJson(instance.createdAt));
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  val['userId'] = instance.userId;
  val['moderated'] = instance.moderated;
  val['location'] = instance.location;
  return val;
}

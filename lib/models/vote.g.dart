// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return Vote(
    json['identifier'] as String,
    json['title'] as String,
    json['choices'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'title': instance.title,
      'choices': instance.choices,
    };

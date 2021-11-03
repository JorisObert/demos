// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVote _$UserVoteFromJson(Map<String, dynamic> json) => UserVote(
      json['choice'] as String,
      dateTimeFromTimestring(json['date'] as String),
      json['userId'] as String,
      json['voteId'] as String,
    );

Map<String, dynamic> _$UserVoteToJson(UserVote instance) => <String, dynamic>{
      'choice': instance.choice,
      'date': dateTimeToTimestamp(instance.date),
      'userId': instance.userId,
      'voteId': instance.voteId,
    };

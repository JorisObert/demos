import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demos/models/user_vote.dart';
import 'package:demos/utils/util_general.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_record.g.dart';

@JsonSerializable()

class UserRecord{

  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp, name: 'last_updated')
  final DateTime? lastUpdated;

  @JsonKey(fromJson: _mapToList)
  final List<UserVote> vote;

  UserRecord(this.lastUpdated, this.vote);

  factory UserRecord.fromJson(Map<String, dynamic> json) =>
      _$UserRecordFromJson(json);
  Map<String, dynamic> toJson() => _$UserRecordToJson(this);

  static List<UserVote> _mapToList(Map<String, dynamic> map){
    List<dynamic> votes = map.values.toList();
    return List.generate(votes.length, (index) => UserVote.fromJson(jsonDecode(votes[index])));
  }

}
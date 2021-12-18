import 'package:demos/utils/util_general.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_vote.g.dart';

@JsonSerializable()
class UserVote {
  final String choice;

  @JsonKey(fromJson: dateTimeFromTimestring, toJson: dateTimeToTimestamp)
  final DateTime date;

  final String userId;

  final String voteId;

  factory UserVote.fromJson(Map<String, dynamic> json) =>
      _$UserVoteFromJson(json);
  Map<String, dynamic> toJson() => _$UserVoteToJson(this);

  UserVote(this.choice, this.date, this.userId, this.voteId);
}

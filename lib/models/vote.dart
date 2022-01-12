import 'package:json_annotation/json_annotation.dart';

part 'vote.g.dart';

@JsonSerializable(explicitToJson: true)
class Vote {

  @JsonKey(toJson: null, includeIfNull: false)
  final String? id;

  String? poolId;

  String? userId;

  String? choiceId;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? createdAt;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? updatedAt;

  Vote({this.id, this.poolId, this.choiceId, this.userId, this.createdAt,
    this.updatedAt,});

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
  Map<String, dynamic> toJson() => _$VoteToJson(this);
}

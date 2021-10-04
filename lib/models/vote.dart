import 'package:json_annotation/json_annotation.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote{

  final String identifier;
  final String title;
  final Map<String, dynamic> choices;

  Vote(this.identifier, this.title, this.choices);

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
  Map<String, dynamic> toJson() => _$VoteToJson(this);

}
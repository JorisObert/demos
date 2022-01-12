import 'package:json_annotation/json_annotation.dart';

part 'choice.g.dart';

@JsonSerializable(explicitToJson: true)
class Choice {
  @JsonKey(toJson: null, includeIfNull: false)
  final String? id;

  String? poolId;

  final String title;

  int nbrVotes;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? createdAt;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? updatedAt;

  Choice({this.id, this.poolId, required this.title, this.nbrVotes = 0,this.createdAt,
    this.updatedAt,});

  factory Choice.fromJson( Map<String, dynamic> json) => _$ChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
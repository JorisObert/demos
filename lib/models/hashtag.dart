
import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable(explicitToJson: true)
class Hashtag {

  @JsonKey(toJson: null, includeIfNull: false)
  final String? id;

  String? title;

  Hashtag({this.id, this.title});

  factory Hashtag.fromJson(Map<String, dynamic> json) => _$HashtagFromJson(json);
  Map<String, dynamic> toJson() => _$HashtagToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'pool_hashtag.g.dart';

@JsonSerializable(explicitToJson: true)
class PoolHashtag {

  @JsonKey(toJson: null, includeIfNull: false)
  final String? id;

  String? poolId;

  String? hashtagId;

  PoolHashtag({this.id, this.poolId, this.hashtagId});

  factory PoolHashtag.fromJson(Map<String, dynamic> json) => _$PoolHashtagFromJson(json);
  Map<String, dynamic> toJson() => _$PoolHashtagToJson(this);
}
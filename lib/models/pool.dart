import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demos/models/demos_user.dart';
import 'package:demos/utils/util_general.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pool.g.dart';

@JsonSerializable()
class Pool {
  String? id;
  final String? identifier;
  final String title;
  final Map<String, int> choices;

  @JsonKey(fromJson: decodeDemosUserFromJson, toJson: encodeDemosUserToJson)
  final DemosUser creator;

  @JsonKey(defaultValue: [])
  final List<String>? hashtags;

  final String? countryCode;

  @JsonKey(defaultValue: false)
  final bool isPrivate;

  @JsonKey(defaultValue: 0)
  final int alert;

  @JsonKey(defaultValue: false)
  final bool hidden;

  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  final DateTime? endDate;

  Pool(
      {this.identifier,
      required this.title,
      required this.choices,
      this.hashtags,
      this.countryCode,
      this.isPrivate = false,
      this.alert = 0,
      this.hidden = false,
      this.endDate,
      required this.creator,
      this.id});

  factory Pool.fromJson(Map<String, dynamic> json) => _$PoolFromJson(json);
  Map<String, dynamic> toJson() => _$PoolToJson(this);
}

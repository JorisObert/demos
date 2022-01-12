

import 'package:demos/models/demos_user.dart';
import 'package:demos/models/hashtag.dart';
import 'package:demos/models/vote.dart';
import 'package:geojson/geojson.dart';
import 'package:json_annotation/json_annotation.dart';

import 'choice.dart';

part 'pool.g.dart';

@JsonSerializable(explicitToJson: true)
class Pool {
  @JsonKey(toJson: null, includeIfNull: false)
  String? id;

  final String title;

  @JsonKey(includeIfNull: false)
  List<Choice>? choices;

  @JsonKey(includeIfNull: false)
  List<Vote>? votes;

  @JsonKey(includeIfNull: false)
  DemosUser? user;

  @JsonKey(fromJson: _decodeHashtags, includeIfNull: false)
  List<Hashtag>? hashtags;

  final String countryCode;

  final String languageCode;

  final bool isPrivate;

  final int alert;

  final bool isHidden;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime? endDate;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? createdAt;

  @JsonKey(toJson: null, includeIfNull: false)
  final DateTime? updatedAt;

  final int totalVotes;

  final String userId;

  final bool moderated;

  final GeoJsonPoint? location;

  Pool(
      {required this.title,
      this.id,
      required this.userId,
      this.user,
      this.choices,
      this.votes,
      this.countryCode = 'us',
      this.languageCode = 'en',
      this.endDate,
      this.isPrivate = false,
      this.alert = 0,
      this.createdAt,
      this.updatedAt,
      this.hashtags,
      this.location,
      this.isHidden = false,
      this.moderated = false,
      this.totalVotes = 0});

  factory Pool.fromJson(Map<String, dynamic> json) => _$PoolFromJson(json);
  Map<String, dynamic> toJson() => _$PoolToJson(this);

  static DateTime? _fromJson(int? int) =>
      int != null ? DateTime.fromMillisecondsSinceEpoch(int) : null;
  static int? _toJson(DateTime? time) => time?.millisecondsSinceEpoch;

  static dynamic _nullableToJson(dynamic value){
    print('were using nullable on ${value.runtimeType}');
    return null;
  }

  static List<Hashtag> _decodeHashtags(dynamic value){
    List<Hashtag> hashtags = [];
    value.forEach((hash){
      hashtags.add(Hashtag.fromJson(hash['hashtag']));
    });
    return hashtags;

  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demos/models/demos_user.dart';
import 'package:flutter/material.dart';

Color getColor(int index) {
  switch (index) {
    case 0:
      return Colors.purpleAccent;
    case 1:
      return Colors.blueGrey;
    case 2:
      return Colors.redAccent;
    default:
      return Colors.purpleAccent;
  }
}

String formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    return '${duration.inDays}d';
  } else if (duration.inHours > 0) {
    return '${duration.inHours}h';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m';
  }
  return '${duration.inSeconds}s';
}

DateTime? dateTimeFromTimestamp(Timestamp? timestamp) {
  if(timestamp == null)return null;
  return DateTime.parse(timestamp.toDate().toString());
}

DateTime dateTimeFromTimestring(String timestring) {
  return DateTime.parse(timestring);
}

String? dateTimeToTimestamp(DateTime? dateTime){
  return dateTime != null ? dateTime.toString() : null;
}

DemosUser decodeDemosUserFromJson(String jsonString){
  print(jsonString);
  return DemosUser.fromJson(jsonDecode(jsonString));
}

String encodeDemosUserToJson(DemosUser demosUser){
  return jsonEncode(demosUser);
}

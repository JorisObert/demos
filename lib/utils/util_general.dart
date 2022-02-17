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

DateTime dateTimeFromTimestring(String timestring) {
  return DateTime.parse(timestring);
}

String? dateTimeToTimestamp(DateTime? dateTime){
  return dateTime != null ? dateTime.toString() : null;
}

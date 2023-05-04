// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Serialization {
  static DateTime? nullableDateTimeFromJson(dynamic timestamp) {
    if (timestamp == null) {
      return null;
    }
    return dateTimeFromJson(timestamp);
  }

  static DateTime dateTimeFromJson(dynamic timestamp) {
    DateTime dateTimeFromJson = DateTime.now();

    try {
      if (timestamp is Timestamp) {
        dateTimeFromJson = timestamp.toDate();
      } else if (timestamp is int) {
        dateTimeFromJson =
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      } else if (timestamp is String) {
        dateTimeFromJson = DateTime.parse(timestamp);
      }
    } catch (e) {
      print(e);
    }

    return dateTimeFromJson;
  }

  static Timestamp? dateTimeToJson(dynamic date) {
    if (date != null) {
      return Timestamp.fromDate(date);
    } else {
      return null;
    }
  }

  static dynamic firebaseDateTimeToJson(dynamic date) {
    if (date != null) {
      return Timestamp.fromDate(date);
    } else {
      return FieldValue.serverTimestamp();
    }
  }

  static RangeValues? rangeValueFromJson(dynamic jso) {
    if (jso == null) return null;
    final Map<String, dynamic> json = Map<String, dynamic>.from(jso);
    return RangeValues((json['start'] as num?)?.toDouble() ?? 0,
        (json['end'] as num?)?.toDouble() ?? 0);
  }

  static Map<String, dynamic>? rangeValueToJson(RangeValues? value) {
    if (value == null) return null;
    return {'start': value.start, 'end': value.end};
  }

  static TimeOfDay timeValueFromJson(dynamic jso) {
    if (jso == null) {
      return const TimeOfDay(
        hour: 06,
        minute: 00,
      );
    } else {
      final Map<String, dynamic> json = Map<String, dynamic>.from(jso);
      return TimeOfDay(
        hour: (json['hour'] as num?)?.toInt() ?? 06,
        minute: (json['minute'] as num?)?.toInt() ?? 0,
      );
    }
  }

  static Map<String, dynamic> timeValueToJson(TimeOfDay? value) {
    if (value == null) {
      return {
        'hour': 06,
        'minute': 00,
      };
    } else {
      return {
        'hour': value.hour,
        'minute': value.minute,
      };
    }
  }

  static Alignment alignmentFromJson(dynamic jso) {
    if (jso == null) return Alignment.center;
    final Map<String, dynamic> json = Map<String, dynamic>.from(jso);
    return Alignment((json['x'] as num?)?.toDouble() ?? 0,
        (json['y'] as num?)?.toDouble() ?? 0);
  }

  static Map<String, dynamic>? alignmentToJson(Alignment? value) {
    if (value == null) return null;
    return {
      'hour': value.x,
      'minute': value.y,
    };
  }

  static String? readStringValue(Map<dynamic, dynamic> json, String key) {
    try {
      return json[key] as String?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static double? readDoubleValue(Map<dynamic, dynamic> json, String key) {
    try {
      return json[key]?.toDouble();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static int? readIntValue(Map<dynamic, dynamic> json, String key) {
    try {
      return json[key] as int?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static bool? readBoolValue(Map<dynamic, dynamic> json, String key) {
    try {
      return json[key] as bool?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Map? readMapValue(Map<dynamic, dynamic> json, String key) {
    try {
      return json[key] as Map?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static List? readListValue(Map<dynamic, dynamic> json, String key) {
    try {
      return json[key] as List?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

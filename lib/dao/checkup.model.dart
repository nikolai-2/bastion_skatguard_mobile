import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'auth.model.dart';
import 'place.model.dart';

class CheckupInfo {
  final int id;
  final int user_id;
  final int place_id;
  final DateTime date;
  final List<int> repeatWhen;
  final List<ShiftZone>? shiftZone;
  final PlaceInfo? place;
  final User? user;

  CheckupInfo({
    required this.id,
    required this.user_id,
    required this.place_id,
    required this.date,
    required this.repeatWhen,
    required this.shiftZone,
    required this.place,
    required this.user,
  });

  CheckupInfo copyWith({
    int? id,
    int? user_id,
    int? place_id,
    DateTime? date,
    List<int>? repeatWhen,
    List<ShiftZone>? shiftZone,
    PlaceInfo? place,
    User? user,
  }) {
    return CheckupInfo(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      place_id: place_id ?? this.place_id,
      date: date ?? this.date,
      repeatWhen: repeatWhen ?? this.repeatWhen,
      shiftZone: shiftZone ?? this.shiftZone,
      place: place ?? this.place,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'place_id': place_id,
      'date': date.millisecondsSinceEpoch,
      'repeat_when': repeatWhen,
      'ShiftZone': shiftZone?.map((x) => x.toMap()).toList(),
      'Place': place?.toMap(),
      'User': place?.toMap(),
    };
  }

  factory CheckupInfo.fromMap(Map<String, dynamic> map) {
    return CheckupInfo(
      id: map['id'],
      user_id: map['user_id'],
      place_id: map['place_id'],
      date: DateTime.parse(map['date']),
      repeatWhen: List<int>.from(map['repeat_when']),
      shiftZone: map['ShiftZone'] == null
          ? null
          : List<ShiftZone>.from(
              map['ShiftZone']?.map((x) => ShiftZone.fromMap(x))),
      place: map['Place'] == null ? null : PlaceInfo.fromMap(map['Place']),
      user: map['User'] == null ? null : User.fromMap(map['User']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckupInfo.fromJson(String source) =>
      CheckupInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CheckupInfo(id: $id, user_id: $user_id, place_id: $place_id, date: $date, repeatWhen: $repeatWhen, shiftZone: $shiftZone, place: $place)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckupInfo &&
        other.id == id &&
        other.user_id == user_id &&
        other.place_id == place_id &&
        other.date == date &&
        listEquals(other.repeatWhen, repeatWhen) &&
        listEquals(other.shiftZone, shiftZone) &&
        other.place == place &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        place_id.hashCode ^
        date.hashCode ^
        repeatWhen.hashCode ^
        shiftZone.hashCode ^
        place.hashCode ^
        user.hashCode;
  }
}

class ShiftZone {
  final int id;
  final int schedule_shift_pattern_id;
  final String zone_id;
  final DateTime date;
  final String comment;
  ShiftZone({
    required this.id,
    required this.schedule_shift_pattern_id,
    required this.zone_id,
    required this.date,
    required this.comment,
  });

  ShiftZone copyWith({
    int? id,
    int? schedule_shift_pattern_id,
    String? zone_id,
    DateTime? date,
    String? comment,
  }) {
    return ShiftZone(
      id: id ?? this.id,
      schedule_shift_pattern_id:
          schedule_shift_pattern_id ?? this.schedule_shift_pattern_id,
      zone_id: zone_id ?? this.zone_id,
      date: date ?? this.date,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule_shift_pattern_id': schedule_shift_pattern_id,
      'zone_id': zone_id,
      'date': date.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  factory ShiftZone.fromMap(Map<String, dynamic> map) {
    return ShiftZone(
      id: map['id'],
      schedule_shift_pattern_id: map['schedule_shift_pattern_id'],
      zone_id: map['zone_id'],
      date: DateTime.parse(map['date']),
      comment: map['comment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftZone.fromJson(String source) =>
      ShiftZone.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShiftZone(id: $id, schedule_shift_pattern_id: $schedule_shift_pattern_id, zone_id: $zone_id, date: $date, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftZone &&
        other.id == id &&
        other.schedule_shift_pattern_id == schedule_shift_pattern_id &&
        other.zone_id == zone_id &&
        other.date == date &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schedule_shift_pattern_id.hashCode ^
        zone_id.hashCode ^
        date.hashCode ^
        comment.hashCode;
  }
}

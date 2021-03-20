import 'dart:convert';

import 'package:flutter/foundation.dart';

class CheckupInfo {
  final int id;
  final int user_id;
  final int place_id;
  final DateTime date;
  final List<int> repeatWhen;
  final List<ShiftZone> shiftZone;
  final PlaceInfo place;
  CheckupInfo({
    required this.id,
    required this.user_id,
    required this.place_id,
    required this.date,
    required this.repeatWhen,
    required this.shiftZone,
    required this.place,
  });

  CheckupInfo copyWith({
    int? id,
    int? user_id,
    int? place_id,
    DateTime? date,
    List<int>? repeatWhen,
    List<ShiftZone>? shiftZone,
    PlaceInfo? place,
  }) {
    return CheckupInfo(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      place_id: place_id ?? this.place_id,
      date: date ?? this.date,
      repeatWhen: repeatWhen ?? this.repeatWhen,
      shiftZone: shiftZone ?? this.shiftZone,
      place: place ?? this.place,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'place_id': place_id,
      'date': date.millisecondsSinceEpoch,
      'repeat_when': repeatWhen,
      'ShiftZone': shiftZone.map((x) => x.toMap()).toList(),
      'Place': place.toMap(),
    };
  }

  factory CheckupInfo.fromMap(Map<String, dynamic> map) {
    return CheckupInfo(
      id: map['id'],
      user_id: map['user_id'],
      place_id: map['place_id'],
      date: DateTime.parse(map['date']),
      repeatWhen: List<int>.from(map['repeat_when']),
      shiftZone: List<ShiftZone>.from(
          map['ShiftZone']?.map((x) => ShiftZone.fromMap(x))),
      place: PlaceInfo.fromMap(map['Place']),
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
        other.place == place;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        place_id.hashCode ^
        date.hashCode ^
        repeatWhen.hashCode ^
        shiftZone.hashCode ^
        place.hashCode;
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

class PlaceInfo {
  final int id;
  final String name;
  final List<ZoneInfo> zone;

  PlaceInfo({
    required this.id,
    required this.name,
    required this.zone,
  });

  PlaceInfo copyWith({
    int? id,
    String? name,
    List<ZoneInfo>? zone,
  }) {
    return PlaceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      zone: zone ?? this.zone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'Zone': zone.map((x) => x.toMap()).toList(),
    };
  }

  factory PlaceInfo.fromMap(Map<String, dynamic> map) {
    return PlaceInfo(
      id: map['id'],
      name: map['name'],
      zone: List<ZoneInfo>.from(map['Zone']?.map((x) => ZoneInfo.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceInfo.fromJson(String source) =>
      PlaceInfo.fromMap(json.decode(source));

  @override
  String toString() => 'PlaceInfo(id: $id, name: $name, zone: $zone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceInfo &&
        other.id == id &&
        other.name == name &&
        listEquals(other.zone, zone);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ zone.hashCode;
}

class ZoneInfo {
  final String id;
  final int place_id;
  final String name;
  ZoneInfo({
    required this.id,
    required this.place_id,
    required this.name,
  });

  ZoneInfo copyWith({
    String? id,
    int? place_id,
    String? name,
  }) {
    return ZoneInfo(
      id: id ?? this.id,
      place_id: place_id ?? this.place_id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place_id': place_id,
      'name': name,
    };
  }

  factory ZoneInfo.fromMap(Map<String, dynamic> map) {
    return ZoneInfo(
      id: map['id'],
      place_id: map['place_id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoneInfo.fromJson(String source) =>
      ZoneInfo.fromMap(json.decode(source));

  @override
  String toString() => 'ZoneInfo(id: $id, place_id: $place_id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ZoneInfo &&
        other.id == id &&
        other.place_id == place_id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ place_id.hashCode ^ name.hashCode;
}

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'checkup.model.dart';

class ExtendedPlaceInfo extends PlaceInfo {
  ExtendedPlaceInfo({
    required int id,
    required String name,
    required List<ZoneInfo> zone,
    required this.scheduleShiftPattern,
  }) : super(
          id: id,
          name: name,
          zone: zone,
        );

  final List<CheckupInfo> scheduleShiftPattern;

  factory ExtendedPlaceInfo.fromMap(Map<String, dynamic> map) {
    return ExtendedPlaceInfo(
      id: map['id'],
      name: map['name'],
      zone: List<ZoneInfo>.from(map['Zone']?.map((x) => ZoneInfo.fromMap(x))),
      scheduleShiftPattern: List<CheckupInfo>.from(
          map['ScheduleShiftPattern']?.map((x) => CheckupInfo.fromMap(x))),
    );
  }

  factory ExtendedPlaceInfo.fromJson(String source) =>
      ExtendedPlaceInfo.fromMap(json.decode(source));

  ExtendedPlaceInfo copyWith({
    int? id,
    String? name,
    List<ZoneInfo>? zone,
    List<CheckupInfo>? scheduleShiftPattern,
  }) {
    return ExtendedPlaceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      zone: zone ?? this.zone,
      scheduleShiftPattern: scheduleShiftPattern ?? this.scheduleShiftPattern,
    );
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

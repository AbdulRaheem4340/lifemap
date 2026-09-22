import 'package:hive/hive.dart';
import 'location_point.dart';

enum SyncStatus { local, syncing, synced }

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 2;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.local;
      case 1:
        return SyncStatus.syncing;
      case 2:
        return SyncStatus.synced;
      default:
        return SyncStatus.local;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.local:
        writer.writeByte(0);
        break;
      case SyncStatus.syncing:
        writer.writeByte(1);
        break;
      case SyncStatus.synced:
        writer.writeByte(2);
        break;
    }
  }
}

class Session {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistanceMeters;
  final int totalDurationSeconds;
  final List<LocationPoint> locationPoints;
  final List<LocationPoint> stopPoints;
  final String? aiSummary;
  final SyncStatus syncStatus;
  final double averageSpeed;
  final double maxSpeed;

  const Session({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.locationPoints,
    required this.stopPoints,
    this.aiSummary,
    this.syncStatus = SyncStatus.local,
    required this.averageSpeed,
    required this.maxSpeed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalDistanceMeters': totalDistanceMeters,
      'totalDurationSeconds': totalDurationSeconds,
      'locationPoints': locationPoints.map((p) => p.toMap()).toList(),
      'stopPoints': stopPoints.map((p) => p.toMap()).toList(),
      'aiSummary': aiSummary,
      'syncStatus': syncStatus.name,
      'averageSpeed': averageSpeed,
      'maxSpeed': maxSpeed,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as String,
      userId: map['userId'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null
          ? DateTime.parse(map['endTime'] as String)
          : null,
      totalDistanceMeters: (map['totalDistanceMeters'] as num).toDouble(),
      totalDurationSeconds: (map['totalDurationSeconds'] as num).toInt(),
      locationPoints: (map['locationPoints'] as List<dynamic>)
          .map((p) => LocationPoint.fromMap(p as Map<String, dynamic>))
          .toList(),
      stopPoints: (map['stopPoints'] as List<dynamic>)
          .map((p) => LocationPoint.fromMap(p as Map<String, dynamic>))
          .toList(),
      aiSummary: map['aiSummary'] as String?,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == map['syncStatus'],
        orElse: () => SyncStatus.local,
      ),
      averageSpeed: (map['averageSpeed'] as num).toDouble(),
      maxSpeed: (map['maxSpeed'] as num).toDouble(),
    );
  }

  Session copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    double? totalDistanceMeters,
    int? totalDurationSeconds,
    List<LocationPoint>? locationPoints,
    List<LocationPoint>? stopPoints,
    String? aiSummary,
    SyncStatus? syncStatus,
    double? averageSpeed,
    double? maxSpeed,
  }) {
    return Session(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      locationPoints: locationPoints ?? this.locationPoints,
      stopPoints: stopPoints ?? this.stopPoints,
      aiSummary: aiSummary ?? this.aiSummary,
      syncStatus: syncStatus ?? this.syncStatus,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
    );
  }
}

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 1;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      id: fields[0] as String,
      userId: fields[1] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(fields[2] as int),
      endTime: fields[3] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[3] as int)
          : null,
      totalDistanceMeters: fields[4] as double,
      totalDurationSeconds: fields[5] as int,
      locationPoints: (fields[6] as List).cast<LocationPoint>(),
      stopPoints: (fields[7] as List).cast<LocationPoint>(),
      aiSummary: fields[8] as String?,
      syncStatus: fields[9] as SyncStatus,
      averageSpeed: fields[10] as double,
      maxSpeed: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.startTime.millisecondsSinceEpoch)
      ..writeByte(3)
      ..write(obj.endTime?.millisecondsSinceEpoch)
      ..writeByte(4)
      ..write(obj.totalDistanceMeters)
      ..writeByte(5)
      ..write(obj.totalDurationSeconds)
      ..writeByte(6)
      ..write(obj.locationPoints)
      ..writeByte(7)
      ..write(obj.stopPoints)
      ..writeByte(8)
      ..write(obj.aiSummary)
      ..writeByte(9)
      ..write(obj.syncStatus)
      ..writeByte(10)
      ..write(obj.averageSpeed)
      ..writeByte(11)
      ..write(obj.maxSpeed);
  }
}
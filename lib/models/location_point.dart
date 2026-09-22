import 'package:hive/hive.dart';

class LocationPoint {
  final String id;
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double accuracy;
  final DateTime timestamp;
  final String sessionId;
  final bool isStopPoint;

  const LocationPoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.accuracy,
    required this.timestamp,
    required this.sessionId,
    this.isStopPoint = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'speed': speed,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'sessionId': sessionId,
      'isStopPoint': isStopPoint,
    };
  }

  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    return LocationPoint(
      id: map['id'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      altitude: (map['altitude'] as num).toDouble(),
      speed: (map['speed'] as num).toDouble(),
      accuracy: (map['accuracy'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp'] as String),
      sessionId: map['sessionId'] as String,
      isStopPoint: map['isStopPoint'] as bool? ?? false,
    );
  }

  LocationPoint copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? altitude,
    double? speed,
    double? accuracy,
    DateTime? timestamp,
    String? sessionId,
    bool? isStopPoint,
  }) {
    return LocationPoint(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
      sessionId: sessionId ?? this.sessionId,
      isStopPoint: isStopPoint ?? this.isStopPoint,
    );
  }
}

class LocationPointAdapter extends TypeAdapter<LocationPoint> {
  @override
  final int typeId = 0;

  @override
  LocationPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationPoint(
      id: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      altitude: fields[3] as double,
      speed: fields[4] as double,
      accuracy: fields[5] as double,
      timestamp: DateTime.fromMillisecondsSinceEpoch(fields[6] as int),
      sessionId: fields[7] as String,
      isStopPoint: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LocationPoint obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.altitude)
      ..writeByte(4)
      ..write(obj.speed)
      ..writeByte(5)
      ..write(obj.accuracy)
      ..writeByte(6)
      ..write(obj.timestamp.millisecondsSinceEpoch)
      ..writeByte(7)
      ..write(obj.sessionId)
      ..writeByte(8)
      ..write(obj.isStopPoint);
  }
}
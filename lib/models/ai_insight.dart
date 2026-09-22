import 'package:hive/hive.dart';

class AIInsight {
  final String id;
  final DateTime weekStart;
  final DateTime weekEnd;
  final String summaryText;
  final List<String> highlights;
  final DateTime generatedAt;
  final int sessionCount;
  final double totalDistanceKm;

  const AIInsight({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    required this.summaryText,
    required this.highlights,
    required this.generatedAt,
    required this.sessionCount,
    required this.totalDistanceKm,
  });
}

class AIInsightAdapter extends TypeAdapter<AIInsight> {
  @override
  final int typeId = 3;

  @override
  AIInsight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIInsight(
      id: fields[0] as String,
      weekStart: DateTime.fromMillisecondsSinceEpoch(fields[1] as int),
      weekEnd: DateTime.fromMillisecondsSinceEpoch(fields[2] as int),
      summaryText: fields[3] as String,
      highlights: (fields[4] as List).cast<String>(),
      generatedAt: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      sessionCount: fields[6] as int,
      totalDistanceKm: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AIInsight obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.weekStart.millisecondsSinceEpoch)
      ..writeByte(2)
      ..write(obj.weekEnd.millisecondsSinceEpoch)
      ..writeByte(3)
      ..write(obj.summaryText)
      ..writeByte(4)
      ..write(obj.highlights)
      ..writeByte(5)
      ..write(obj.generatedAt.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.sessionCount)
      ..writeByte(7)
      ..write(obj.totalDistanceKm);
  }
}


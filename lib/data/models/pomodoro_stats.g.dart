// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroStatsAdapter extends TypeAdapter<PomodoroStats> {
  @override
  final typeId = 3;

  @override
  PomodoroStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroStats(
      totalAllTimeMinutes: fields[0] == null ? 0 : (fields[0] as num).toInt(),
      totalAllTimeSessions: fields[1] == null ? 0 : (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroStats obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.totalAllTimeMinutes)
      ..writeByte(1)
      ..write(obj.totalAllTimeSessions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

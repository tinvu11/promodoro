// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStatAdapter extends TypeAdapter<DailyStat> {
  @override
  final typeId = 2;

  @override
  DailyStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStat(
      date: fields[0] as DateTime,
      minutes: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      sessions: fields[2] == null ? 0 : (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyStat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.minutes)
      ..writeByte(2)
      ..write(obj.sessions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

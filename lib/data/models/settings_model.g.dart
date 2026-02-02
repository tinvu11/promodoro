// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final typeId = 0;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      workTime: (fields[0] as num).toInt(),
      breakTime: (fields[1] as num).toInt(),
      repeatCount: (fields[2] as num).toInt(),
      isSoundEnabled: fields[3] as bool,
      selectedThemeId: fields[4] as String,
      alarmWork: fields[5] as String,
      alarmBreak: fields[6] as String,
      volumeWorkAlarm: (fields[7] as num).toDouble(),
      volumeBreakAlarm: (fields[8] as num).toDouble(),
      volumeNoise: (fields[9] as num).toDouble(),
      alwaysOnScreen: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.workTime)
      ..writeByte(1)
      ..write(obj.breakTime)
      ..writeByte(2)
      ..write(obj.repeatCount)
      ..writeByte(3)
      ..write(obj.isSoundEnabled)
      ..writeByte(4)
      ..write(obj.selectedThemeId)
      ..writeByte(5)
      ..write(obj.alarmWork)
      ..writeByte(6)
      ..write(obj.alarmBreak)
      ..writeByte(7)
      ..write(obj.volumeWorkAlarm)
      ..writeByte(8)
      ..write(obj.volumeBreakAlarm)
      ..writeByte(9)
      ..write(obj.volumeNoise)
      ..writeByte(10)
      ..write(obj.alwaysOnScreen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

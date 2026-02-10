
import 'package:hive_ce/hive.dart';

import '../../configs/hive/hive_types.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: HiveTypes.alarm)
class AlarmModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String path;

  const AlarmModel({
    required this.id,
    required this.name,
    required this.path,
  });
  AlarmModel copyWith({
    String? id,
    String? name,
    String? path,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }
  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
    );
  }
}

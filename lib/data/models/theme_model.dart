import 'package:hive_ce/hive.dart';

import '../../configs/hive/hive_types.dart';

part 'theme_model.g.dart';

@HiveType(typeId: HiveTypes.themeModel)
class ThemeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String audioUrl;

  @HiveField(4)
  final bool isPremium;

  ThemeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.audioUrl,
    required this.isPremium,
  });

  factory ThemeModel.formFirebase(Map<String, dynamic> data, String id) {
    return ThemeModel(
      id: id,
      name: data['title'],
      imageUrl: data['imageUrl'],
      audioUrl: data['audioUrl'],
      isPremium: data['isPremium'],
    );
  }
}

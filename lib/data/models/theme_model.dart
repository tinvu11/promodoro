import 'package:hive_ce/hive.dart';

import '../../configs/hive/hive_types.dart';

part 'theme_model.g.dart';

@HiveType(typeId: HiveTypes.themeModel)
class ThemeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Map<String, String> titleMap;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String audioUrl;

  @HiveField(4)
  final bool isPremium;

  ThemeModel({
    required this.id,
    required this.titleMap,
    required this.imageUrl,
    required this.audioUrl,
    required this.isPremium,
  });

  /// Lấy tên theme theo ngôn ngữ hiện tại, fallback về 'en' hoặc giá trị đầu tiên.
  String getLocalizedName(String languageCode) {
    return titleMap[languageCode] ??
        titleMap['en'] ??
        titleMap.values.firstOrNull ??
        '';
  }

  factory ThemeModel.formFirebase(Map<String, dynamic> data, String id) {
    final rawTitle = data['title'];
    final Map<String, String> titleMap;
    if (rawTitle is Map) {
      titleMap = rawTitle.map((k, v) => MapEntry(k.toString(), v.toString()));
    } else {
      titleMap = {'en': rawTitle?.toString() ?? ''};
    }
    return ThemeModel(
      id: id,
      titleMap: titleMap,
      imageUrl: data['imageUrl'],
      audioUrl: data['audioUrl'],
      isPremium: data['isPremium'],
    );
  }
}

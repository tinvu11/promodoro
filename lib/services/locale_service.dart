import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// Các thư mục l10n/generated dc tao qua lẹnh flutter gen-l10n hoặc có thể tự động khi run/build app
/// Service quản lý ngôn ngữ theo 3 mức ưu tiên:
/// 1. Lựa chọn thủ công của người dùng (lưu SharedPreferences)
/// 2. Ngôn ngữ hệ điều hành
/// 3. Fallback sang tiếng Anh nếu ngôn ngữ không được hỗ trợ
class LocaleService {
  static const _key = 'selected_locale';

  /// Danh sách ngôn ngữ app hỗ trợ
  static const supportedLocales = [Locale('en'), Locale('vi')];

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Lấy locale đã lưu (ưu tiên 1)
  String? getSavedLocaleCode() {
    return _prefs?.getString(_key);
  }

  /// Lưu lựa chọn ngôn ngữ của người dùng
  Future<void> saveLocale(String languageCode) async {
    await _prefs?.setString(_key, languageCode);
  }

  /// Xoá lựa chọn (reset về auto)
  Future<void> clearLocale() async {
    await _prefs?.remove(_key);
  }

  /// Xác định locale theo 3 mức ưu tiên:
  /// 1. Người dùng đã chọn thủ công → dùng locale đã lưu
  /// 2. Lần đầu mở app → lấy ngôn ngữ hệ điều hành
  /// 3. Ngôn ngữ OS không được hỗ trợ → fallback sang English
  Locale resolveLocale() {
    // Ưu tiên 1: Lựa chọn thủ công
    final saved = getSavedLocaleCode();
    if (saved != null && _isSupported(saved)) {
      return Locale(saved);
    }

    // Ưu tiên 2: Ngôn ngữ hệ điều hành
    final deviceLocale = PlatformDispatcher.instance.locale;
    if (_isSupported(deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    }

    // Ưu tiên 3: Fallback → English
    return const Locale('en');
  }

  bool _isSupported(String languageCode) {
    return supportedLocales.any((l) => l.languageCode == languageCode);
  }

  /// Tên hiển thị của locale (luôn hiển thị tên gốc của ngôn ngữ)
  static String displayName(String languageCode) {
    switch (languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }
}

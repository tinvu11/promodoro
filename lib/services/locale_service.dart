import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// Resolves app locale with this priority order:
/// user-selected locale, device locale, then English fallback.
class LocaleService {
  static const _key = 'selected_locale';

  /// Locales supported by the app.
  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('de'),
    Locale('it'),
    Locale('ru'),
    Locale('pt'),
    Locale('zh'),
    Locale('hi'),
    Locale('ar'),
    Locale('id'),
    Locale('tr'),
    Locale('sv'),
    Locale('nl'),
  ];

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Returns persisted locale code if user selected one.
  String? getSavedLocaleCode() {
    return _prefs?.getString(_key);
  }

  /// Persists user-selected locale.
  Future<void> saveLocale(String languageCode) async {
    await _prefs?.setString(_key, languageCode);
  }

  /// Clears persisted locale and returns to automatic resolution.
  Future<void> clearLocale() async {
    await _prefs?.remove(_key);
  }

  /// Resolves locale using persisted value, device locale, then `en`.
  Locale resolveLocale() {
    final saved = getSavedLocaleCode();
    if (saved != null && _isSupported(saved)) {
      return Locale(saved);
    }

    final deviceLocale = PlatformDispatcher.instance.locale;
    if (_isSupported(deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    }

    return const Locale('en');
  }

  bool _isSupported(String languageCode) {
    return supportedLocales.any((l) => l.languageCode == languageCode);
  }

  /// Human-readable language name for a given code.
  static String displayName(String languageCode) {
    switch (languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'ru':
        return 'Русский';
      case 'pt':
        return 'Português';
      case 'zh':
        return '简体中文';
      case 'hi':
        return 'हिन्दी';
      case 'ar':
        return 'العربية';
      case 'id':
        return 'Bahasa Indonesia';
      case 'tr':
        return 'Türkçe';
      case 'sv':
        return 'Svenska';
      case 'nl':
        return 'Nederlands';
      default:
        return languageCode.toUpperCase();
    }
  }
}

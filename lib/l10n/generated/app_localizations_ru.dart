// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Таймер';

  @override
  String get statisticsTab => 'Статистика';

  @override
  String get settingsTab => 'Настройки';

  @override
  String get settings => 'Настройки';

  @override
  String get workTime => 'Фокус';

  @override
  String get breakTime => 'Отдых';

  @override
  String get duration => 'Длительность';

  @override
  String get focus => 'Фокус';

  @override
  String get rest => 'Отдых';

  @override
  String get alarm => 'Будильник';

  @override
  String get volume => 'Громкость';

  @override
  String get repeatCount => 'Сессия';

  @override
  String repeatTimes(int count) {
    return '$count сес.';
  }

  @override
  String get repeat => 'Повтор';

  @override
  String minutes(int count) {
    return '$count мин';
  }

  @override
  String get sound => 'Звук';

  @override
  String get backgroundSound => 'Фоновый звук';

  @override
  String get language => 'Язык';

  @override
  String get alwaysOnScreen => 'Экран всегда включен';

  @override
  String get information => 'Информация';

  @override
  String get work => 'Работа';

  @override
  String get breakLabel => 'Перерыв';

  @override
  String get start => 'Старт';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get pause => 'Пауза';

  @override
  String get statistics => 'Статистика';

  @override
  String get total => 'Всего';

  @override
  String get today => 'Сегодня';

  @override
  String get sessions => 'сессий';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hoursч ${mins}m';
  }

  @override
  String hoursOnly(int hours) {
    return '${hours}h';
  }

  @override
  String minutesOnly(int mins) {
    return '${mins}m';
  }

  @override
  String totalLabel(String value) {
    return 'Итого: $value';
  }

  @override
  String get premiumFeatures => 'Премиум функции';

  @override
  String get unlockAllFeatures => 'Разблокировать всё';

  @override
  String get noAds => 'Без рекламы';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'Навсегда';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'Ежегодно';

  @override
  String get save40 => 'Скидка 40%';

  @override
  String get terms => 'Условия';

  @override
  String get restore => 'Восстановить';

  @override
  String get policy => 'Политика';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Вьетнамский';

  @override
  String get english => 'Английский';

  @override
  String get languageSelection => 'Выбор языка';
}

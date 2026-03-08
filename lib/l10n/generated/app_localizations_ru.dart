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
    return '$hoursч';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins м';
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
  String get prioritySupport => 'Приоритетная поддержка команды';

  @override
  String get optimizePerformance => 'Оптимизация производительности';

  @override
  String get lifetime => 'Навсегда';

  @override
  String get buyOnce => 'Купи один раз, используй навсегда';

  @override
  String get yearly => 'Ежегодно';

  @override
  String get save40 => 'Скидка 40%';

  @override
  String get terms => 'Условия использования';

  @override
  String get restore => 'Восстановить';

  @override
  String get policy => 'Политика конфиденциальности';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Вьетнамский';

  @override
  String get english => 'Английский';

  @override
  String get languageSelection => 'Выбор языка';

  @override
  String get noData => 'Данные не найдены';

  @override
  String get noInternet => 'Нет подключения к Интернету.';

  @override
  String get tryAgainConnect => 'Пожалуйста, попробуйте подключиться еще раз.';

  @override
  String get tryAgain => 'Попробуйте еще раз';

  @override
  String get sponsored => 'Спонсировано';

  @override
  String get stop_timer_title => 'Остановить таймер';

  @override
  String get stop_timer_content =>
      'Пожалуйста, остановите таймер перед изменением настроек.';

  @override
  String get btn_stop => 'Стоп';

  @override
  String get btn_cancel => 'Отмена';

  @override
  String get version => 'Версия';

  @override
  String get email => 'Электронная почта';

  @override
  String get share => 'Поделиться';

  @override
  String get rate => 'Оценить';
}

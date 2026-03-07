// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Temporizador';

  @override
  String get statisticsTab => 'Estadísticas';

  @override
  String get settingsTab => 'Ajustes';

  @override
  String get settings => 'Ajustes';

  @override
  String get workTime => 'Enfoque';

  @override
  String get breakTime => 'Descanso';

  @override
  String get duration => 'Duración';

  @override
  String get focus => 'Enfoque';

  @override
  String get rest => 'Descanso';

  @override
  String get alarm => 'Alarma';

  @override
  String get volume => 'Volumen';

  @override
  String get repeatCount => 'Sesión';

  @override
  String repeatTimes(int count) {
    return '$count ses';
  }

  @override
  String get repeat => 'Repetir';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get sound => 'Sonido';

  @override
  String get backgroundSound => 'Sonido de fondo';

  @override
  String get language => 'Idioma';

  @override
  String get alwaysOnScreen => 'Siempre en pantalla';

  @override
  String get information => 'Información';

  @override
  String get work => 'Trabajo';

  @override
  String get breakLabel => 'Descanso';

  @override
  String get start => 'Empezar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get pause => 'Pausa';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get total => 'Total';

  @override
  String get today => 'Hoy';

  @override
  String get sessions => 'sesiones';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}h ${mins}m';
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
    return 'Total: $value';
  }

  @override
  String get premiumFeatures => 'Funciones Premium';

  @override
  String get unlockAllFeatures => 'Desbloquear todo';

  @override
  String get noAds => 'Sin anuncios';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'De por vida';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'Anual';

  @override
  String get save40 => 'Ahorra 40%';

  @override
  String get terms => 'Términos';

  @override
  String get restore => 'Restaurar';

  @override
  String get policy => 'Política';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get english => 'Inglés';

  @override
  String get languageSelection => 'Seleccionar idioma';
}

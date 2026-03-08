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
  String get prioritySupport => 'Soporte del equipo prioritario';

  @override
  String get optimizePerformance => 'Optimizar el rendimiento';

  @override
  String get lifetime => 'De por vida';

  @override
  String get buyOnce => 'Compra una vez, úsalo para siempre';

  @override
  String get yearly => 'Anual';

  @override
  String get save40 => 'Ahorra 40%';

  @override
  String get terms => 'Términos de uso';

  @override
  String get restore => 'Restaurar';

  @override
  String get policy => 'Política de privacidad';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get english => 'Inglés';

  @override
  String get languageSelection => 'Seleccionar idioma';

  @override
  String get noData => 'No se encontraron datos';

  @override
  String get noInternet => 'Sin conexión a Internet.';

  @override
  String get tryAgainConnect => 'Intente conectarse nuevamente.';

  @override
  String get tryAgain => 'Intentar otra vez';

  @override
  String get sponsored => 'Patrocinado';

  @override
  String get stop_timer_title => 'Detener temporizador';

  @override
  String get stop_timer_content =>
      'Por favor, detenga el temporizador antes de cambiar la configuración.';

  @override
  String get btn_stop => 'Detener';

  @override
  String get btn_cancel => 'Cancelar';

  @override
  String get version => 'Versión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get share => 'Compartir';

  @override
  String get rate => 'Calificar';
}

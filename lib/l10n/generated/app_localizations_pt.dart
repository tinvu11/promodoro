// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Estatísticas';

  @override
  String get settingsTab => 'Ajustes';

  @override
  String get settings => 'Configurações';

  @override
  String get workTime => 'Foco';

  @override
  String get breakTime => 'Pausa';

  @override
  String get duration => 'Duração';

  @override
  String get focus => 'Foco';

  @override
  String get rest => 'Descanso';

  @override
  String get alarm => 'Alarme';

  @override
  String get volume => 'Volume';

  @override
  String get repeatCount => 'Sessão';

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
  String get sound => 'Som';

  @override
  String get backgroundSound => 'Som de fundo';

  @override
  String get language => 'Idioma';

  @override
  String get alwaysOnScreen => 'Sempre ligado';

  @override
  String get information => 'Informação';

  @override
  String get work => 'Trabalho';

  @override
  String get breakLabel => 'Pausa';

  @override
  String get start => 'Iniciar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get pause => 'Pausa';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get total => 'Total';

  @override
  String get today => 'Hoje';

  @override
  String get sessions => 'sessões';

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
  String get premiumFeatures => 'Recursos Premium';

  @override
  String get unlockAllFeatures => 'Desbloquear tudo';

  @override
  String get noAds => 'Sem anúncios';

  @override
  String get prioritySupport => 'Suporte prioritário da equipe';

  @override
  String get optimizePerformance => 'Otimize o desempenho';

  @override
  String get lifetime => 'Vitalício';

  @override
  String get buyOnce => 'Compre uma vez, use para sempre';

  @override
  String get yearly => 'Anual';

  @override
  String get save40 => 'Economize 40%';

  @override
  String get terms => 'Termos de Uso';

  @override
  String get restore => 'Restaurar';

  @override
  String get policy => 'Política de Privacidade';

  @override
  String get hot => 'QUENTE';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get english => 'Inglês';

  @override
  String get languageSelection => 'Idioma';

  @override
  String get noData => 'Nenhum dado encontrado';

  @override
  String get noInternet => 'Sem conexão com a internet.';

  @override
  String get tryAgainConnect => 'Tente conectar novamente.';

  @override
  String get tryAgain => 'Tente novamente';

  @override
  String get sponsored => 'Patrocinado';

  @override
  String get stop_timer_title => 'Parar o temporizador';

  @override
  String get stop_timer_content =>
      'Por favor, pare o temporizador antes de alterar as configurações.';

  @override
  String get btn_stop => 'Parar';

  @override
  String get btn_cancel => 'Cancelar';

  @override
  String get version => 'Versão';

  @override
  String get email => 'Email';

  @override
  String get share => 'Compartilhar';

  @override
  String get rate => 'Avaliar';

  @override
  String get term_pw => 'Termos';

  @override
  String get policy_pw => 'Política';
}

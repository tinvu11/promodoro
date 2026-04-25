import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:pomodoro/configs/dio/app_dio.dart';
import 'package:pomodoro/data/data_sources/remote_data.dart';
import 'package:pomodoro/data/repositories/iap_repository.dart';
import 'package:pomodoro/data/repositories/remote_data_repo.dart';
import 'package:pomodoro/data/repositories/settings_repository.dart';
import 'package:pomodoro/data/repositories/stat_repository.dart';
import 'package:pomodoro/services/locale_service.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/bloc/locale/locale_cubit.dart';
import 'package:pomodoro/ui/screens/noises/bloc/noises_bloc.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:pomodoro/ui/screens/static/bloc/static_bloc.dart';
import 'package:pomodoro/ui/screens/timer/bloc/timer_bloc.dart';
import 'package:pomodoro/ui/screens/timer/ticker.dart';
import 'package:pomodoro/services/timer_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pomodoro/services/audio_service.dart';

import '../data/data_sources/local_data.dart';
import '../ui/bloc/iap/iap_bloc.dart';
import 'hive/app_hive.dart';

class DI {
  static final sl = GetIt.instance;

  static Future<void> init() async {
    // Initialize independent I/O services in parallel to reduce startup time.
    final appHive = AppHive();
    final localeService = LocaleService();
    final themeStorageService = ThemeStorageService(dio: AppDio.instance);

    await Future.wait([
      appHive.init(),
      localeService.init(),
      themeStorageService.init(),
    ]);

    // Register dependencies after async initialization is complete.
    sl.registerLazySingleton<AppHive>(() => appHive);
    sl.registerLazySingleton<LocalData>(() => HiveDatabase(appHive: sl()));

    sl.registerLazySingleton<LocaleService>(() => localeService);
    sl.registerLazySingleton<LocaleCubit>(
      () => LocaleCubit(localeService: sl()),
    );

    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localData: sl()),
    );
    sl.registerLazySingleton<StatRepository>(
      () => StatRepositoryImpl(localData: sl()),
    );

    // Register Firebase before consumers that depend on it.
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    sl.registerLazySingleton<RemoteData>(() => RemoteDataImpl(firestore: sl()));
    sl.registerLazySingleton<RemoteDataRepo>(
      () => RemoteDataRepoImpl(remoteData: sl(), localData: sl()),
    );
    sl.registerLazySingleton<IapRepository>(() => IapRepositoryImpl());

    sl.registerLazySingleton<ThemeStorageService>(() => themeStorageService);

    sl.registerLazySingleton<SettingsBloc>(
      () => SettingsBloc(settingsRepository: sl())..add(GetSettingsEvent()),
    );
    sl.registerLazySingleton<Ticker>(() => Ticker());
    sl.registerLazySingleton<TimerBloc>(() => TimerBloc());
    sl.registerLazySingleton<StaticBloc>(
      () => StaticBloc(statRepository: sl())..add(LoadStaticEvent()),
    );
    sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin(),
    );
    sl.registerLazySingleton<PomodoroAudioService>(
      () => PomodoroAudioService(themeStorageService: sl()),
    );
    sl.registerFactoryParam<PomodoroTimerController, ServiceInstance, void>(
      (service, _) => PomodoroTimerController(
        service: service,
        notifications: sl<FlutterLocalNotificationsPlugin>(),
        statRepository: sl<StatRepository>(),
        audioService: sl<PomodoroAudioService>(),
      ),
    );

    // Delay noise loading until the Noises page is opened.
    sl.registerLazySingleton<NoisesBloc>(
      () => NoisesBloc(remoteDataRepo: sl(), themeStorageService: sl()),
    );

    sl.registerLazySingleton<IapBloc>(
      () => IapBloc(iapRepository: sl(), amplitude: sl()),
    );

    const apiKey = String.fromEnvironment('AMPLITUDE_API_KEY');
    final amplitude = Amplitude(Configuration(apiKey: apiKey));
    sl.registerLazySingleton<Amplitude>(() => amplitude);
  }
}

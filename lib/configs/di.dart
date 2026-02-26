import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:promodoro/configs/dio/app_dio.dart';
import 'package:promodoro/data/data_sources/remote_data.dart';
import 'package:promodoro/data/repositories/iap_repository.dart';
import 'package:promodoro/data/repositories/remote_data_repo.dart';
import 'package:promodoro/data/repositories/settings_repository.dart';
import 'package:promodoro/data/repositories/stat_repository.dart';
import 'package:promodoro/services/noise_audio_service.dart';
import 'package:promodoro/services/theme_storage_service.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_bloc.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:promodoro/ui/screens/static/bloc/static_bloc.dart';
import 'package:promodoro/ui/screens/timer/bloc/timer_bloc.dart';
import 'package:promodoro/ui/screens/timer/ticker.dart';

import '../data/data_sources/local_data.dart';
import '../ui/bloc/iap/iap_bloc.dart';
import 'hive/app_hive.dart';

class DI {
  static final sl = GetIt.instance;

  static Future<void> init() async {
    final appHive = AppHive();
    await appHive.init();
    sl.registerLazySingleton<AppHive>(() => appHive);
    sl.registerLazySingleton<LocalData>(() => HiveDatabase(appHive: sl()));

    // Repositories
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localData: sl()),
    );
    sl.registerLazySingleton<StatRepository>(
      () => StatRepositoryImpl(localData: sl()),
    );

    // Auth
    // sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

    // Firebase (đăng ký trước các dependency phụ thuộc)
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    sl.registerLazySingleton<RemoteData>(() => RemoteDataImpl(firestore: sl()));
    sl.registerLazySingleton<RemoteDataRepo>(
      () => RemoteDataRepoImpl(remoteData: sl(), localData: sl()),
    );
    sl.registerLazySingleton<IapRepository>(() => IapRepositoryImpl());

    // Services
    final themeStorageService = ThemeStorageService(dio: AppDio.instance);
    await themeStorageService.init();
    sl.registerLazySingleton<ThemeStorageService>(() => themeStorageService);
    sl.registerLazySingleton<NoiseAudioService>(
      () => NoiseAudioService(themeStorageService: sl()),
    );

    // BLoCs
    sl.registerLazySingleton(
      () => SettingsBloc(settingsRepository: sl())..add(GetSettingsEvent()),
    );
    sl.registerLazySingleton(() => Ticker());
    sl.registerLazySingleton(() => TimerBloc(statRepository: sl()));
    sl.registerLazySingleton(
      () => StaticBloc(statRepository: sl())..add(LoadStaticEvent()),
    );
    // NoisesBloc: KHÔNG fire LoadNoises ở đây — defer đến khi mở NoisesPage
    sl.registerLazySingleton(
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

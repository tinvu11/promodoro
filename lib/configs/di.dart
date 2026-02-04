import 'package:get_it/get_it.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';

import '../data/data_sources/local_data.dart';
import 'hive/app_hive.dart';

class DI {
  static final sl = GetIt.instance;
  static Future<void> init() async {
    final appHive = AppHive();
    await appHive.init();
    sl.registerLazySingleton<AppHive>(() => appHive);
    sl.registerLazySingleton<LocalData>(() => HiveDatabase(appHive: sl()));
    sl.registerLazySingleton(() => SettingsBloc(localData: sl()));
  }
}

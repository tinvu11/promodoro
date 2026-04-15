import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pomodoro/services/background_service.dart';
import 'package:pomodoro/simple_bloc_observer.dart';
import 'package:pomodoro/ui/bloc/iap/iap_bloc.dart';
import 'package:pomodoro/ui/bloc/locale/locale_cubit.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:pomodoro/ui/screens/timer/bloc/timer_bloc.dart';

import 'app.dart';
import 'configs/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run independent startup tasks concurrently.
  await Future.wait([Firebase.initializeApp(), initializeService()]);

  // Initialize DI after Firebase because some services depend on it.
  await DI.init();

  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DI.sl<IapBloc>()),
        BlocProvider(create: (context) => DI.sl<SettingsBloc>()),
        BlocProvider(create: (context) => DI.sl<LocaleCubit>()),
        BlocProvider(create: (context) => DI.sl<TimerBloc>()),
      ],
      child: const App(),
    ),
  );

  // Delay ad SDK initialization to avoid blocking first frame.
  MobileAds.instance.initialize();
}

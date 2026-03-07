import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:promodoro/services/background_service.dart';
import 'package:promodoro/simple_bloc_observer.dart';
import 'package:promodoro/ui/bloc/iap/iap_bloc.dart';
import 'package:promodoro/ui/bloc/locale/locale_cubit.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:promodoro/ui/screens/timer/bloc/timer_bloc.dart';

import 'app.dart';
import 'configs/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chạy song song 2 tác vụ độc lập để tăng tốc khởi động
  await Future.wait([initializeService(), Firebase.initializeApp()]);

  // DI phải init SAU Firebase vì một số dependency cần Firebase
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

  // Khởi tạo MobileAds SAU runApp – không cần cho frame đầu tiên,
  // tiết kiệm ~1-2 giây trước khi UI hiện ra.
  MobileAds.instance.initialize();
}

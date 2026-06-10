import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/navigation/app_router.dart';
import 'package:pomodoro/services/locale_service.dart';
import 'package:pomodoro/services/timer_background_service.dart';
import 'package:pomodoro/ui/bloc/locale/locale_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // Khi app bị kill/xoá khỏi đa nhiệm, yêu cầu service tự tắt nếu timer không đang chạy
      PomodoroBackgroundService().service.invoke('stopIfPaused');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          title: 'Pemo',
          routerConfig: AppRouter.router,
          theme: ThemeData.dark(),
          locale: locale,
          supportedLocales: LocaleService.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

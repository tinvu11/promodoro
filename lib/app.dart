import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/navigation/app_router.dart';
import 'package:pomodoro/services/locale_service.dart';
import 'package:pomodoro/ui/bloc/locale/locale_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  void _safeInvokeService(String method, [Map<String, dynamic>? args]) {
    try {
      FlutterBackgroundService().invoke(method, args);
    } catch (_) {
      // Ignore platforms where background service is unavailable.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _safeInvokeService('ui_state', {'is_foreground': true});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _safeInvokeService('ui_state', {'is_foreground': true});
    } else if (state == AppLifecycleState.paused) {
      _safeInvokeService('ui_state', {'is_foreground': false});
    } else if (state == AppLifecycleState.detached) {
      _safeInvokeService('ui_detached');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: ThemeData.dark(),
          locale: locale,
          supportedLocales: LocaleService.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}

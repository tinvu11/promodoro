import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/l10n/generated/app_localizations.dart';
import 'package:promodoro/navigation/app_router.dart';
import 'package:promodoro/services/locale_service.dart';
import 'package:promodoro/ui/bloc/locale/locale_cubit.dart';

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
    // Mặc định khi init là đang ở foreground
    FlutterBackgroundService().invoke('ui_state', {'is_foreground': true});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final service = FlutterBackgroundService();
    if (state == AppLifecycleState.resumed) {
      service.invoke('ui_state', {'is_foreground': true});
    } else if (state == AppLifecycleState.paused) {
      service.invoke('ui_state', {'is_foreground': false});
    } else if (state == AppLifecycleState.detached) {
      service.invoke('stopService');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          // showPerformanceOverlay: true,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pomodoro/navigation/app_router.dart';
import 'package:pomodoro/services/locale_service.dart';
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
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return WithForegroundTask(
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            theme: ThemeData.dark(),
            locale: locale,
            supportedLocales: LocaleService.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

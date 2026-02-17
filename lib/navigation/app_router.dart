import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/ui/screens/home_navigation/home_navigation.dart';
import 'package:promodoro/ui/screens/languages/languages_page.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_bloc.dart';
import 'package:promodoro/ui/screens/noises/noises_page.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:promodoro/ui/screens/static/bloc/static_bloc.dart';
import 'package:promodoro/ui/screens/static/static_page.dart';

import '../configs/di.dart';
import '../ui/screens/settings/settings_page.dart';
import '../ui/screens/timer/bloc/timer_bloc.dart';
import '../ui/screens/timer/timer_page.dart';

part 'route_paths.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePaths.timer,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BlocProvider.value(
          value: DI.sl<TimerBloc>(),
          child: HomeNavigation(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.timer,
                // builder: (context, state) => BlocProvider.value(value: DI.sl<SettingsBloc>(), child: TimerPage()),
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: DI.sl<SettingsBloc>()),
                    BlocProvider.value(value: DI.sl<TimerBloc>()),
                  ],
                  child: TimerPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.static,
                builder: (context, state) => BlocProvider.value(
                  value: DI.sl<StaticBloc>(),
                  child: const StaticPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) => BlocProvider.value(
                  value: DI.sl<SettingsBloc>(),
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.noises,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider.value(
            value: DI.sl<NoisesBloc>(),
            child: const NoisesPage(),
          ),
        ),
        // pageBuilder: (context, state) =>
        //     buildPageWithDefaultTransition<void>(context: context, state: state, child: NoisesPage()),
      ),

      GoRoute(
        path: RoutePaths.language,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider.value(
            value: DI.sl<SettingsBloc>(),
            child: const LanguagesPage(),
          ),
        ),
      ),
    ],
  );
}

CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );

      return ScaleTransition(
        scale: Tween<double>(begin: 0.90, end: 1.0).animate(curved),
        child: child,
      );
    },
  );
}

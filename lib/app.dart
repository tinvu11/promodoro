import 'package:flutter/material.dart';
import 'package:promodoro/navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(showPerformanceOverlay: true, routerConfig: AppRouter.router, theme: ThemeData.dark());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:promodoro/navigation/app_router.dart';

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
    if (state == AppLifecycleState.detached) {
      FlutterBackgroundService().invoke('stopServiceIfPaused');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // showPerformanceOverlay: true,
      routerConfig: AppRouter.router,
      theme: ThemeData.dark(),
    );
  }
}

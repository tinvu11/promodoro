import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:promodoro/services/background_service.dart';
import 'package:promodoro/simple_bloc_observer.dart';
import 'package:promodoro/ui/bloc/iap/iap_bloc.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';

import 'app.dart';
import 'configs/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chạy song song 2 tác vụ độc lập để tăng tốc khởi động
  await Future.wait([initializeService(), _initFirebase()]);

  // DI phải init SAU Firebase vì một số dependency cần Firebase
  await DI.init();

  // Đăng nhập ẩn danh (tạo tài khoản nếu chưa có)
  // await DI.sl<AuthRepository>().signInAnonymously();

  await MobileAds.instance.initialize();
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DI.sl<IapBloc>()),
        BlocProvider(create: (context) => DI.sl<SettingsBloc>()),
      ],
      child: const App(),
    ),
  );
}

/// Khởi tạo Firebase với timeout 15s để tránh treo app
Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        log('[Main] Firebase.initializeApp() timeout after 15s');
        throw TimeoutException('Firebase init timeout');
      },
    );
  } catch (e) {
    log('[Main] Firebase init failed: $e');
    // Cho phép app tiếp tục chạy, các tính năng Firebase sẽ fail gracefully
  }
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);

  @override
  String toString() => message;
}

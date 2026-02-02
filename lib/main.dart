import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:promodoro/simple_bloc_observer.dart';

import 'app.dart';
import 'configs/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs bloc events and errors in debug builds.
class SimpleBlocObserver extends BlocObserver {
  static const String reset = '\x1B[0m';
  static const String blue = '\x1B[34m';
  static const String red = '\x1B[31m';
  static const String bold = '\x1B[1m';

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    if (kDebugMode) {
      print(
        '$blue\n'
        '--------------------------------\n'
        'Bloc  : ${bloc.runtimeType}     \n'
        'Event : ${event.toString()}     \n'
        '--------------------------------$reset\n',
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    if (kDebugMode) {
      print(
        '$red$bold\n'
        '════════════════════════════════════════\n'
        '               BLOC ERROR               \n'
        '════════════════════════════════════════\n'
        'Bloc   : ${bloc.runtimeType}          \n\n'
        'Error  : $error                         \n'
        'StackTrace:\n$stackTrace                \n'
        '════════════════════════════════════════$reset\n',
      );
    }
  }
}

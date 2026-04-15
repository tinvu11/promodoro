import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/services/locale_service.dart';

/// Cubit quản lý trạng thái locale hiện tại của app.
class LocaleCubit extends Cubit<Locale> {
  final LocaleService _localeService;

  LocaleCubit({required LocaleService localeService})
    : _localeService = localeService,
      super(localeService.resolveLocale());

  /// Người dùng chọn ngôn ngữ thủ công trên trang Languages
  Future<void> changeLocale(String languageCode) async {
    await _localeService.saveLocale(languageCode);
    emit(Locale(languageCode));
  }

  /// Lấy language code hiện tại
  String get currentLanguageCode => state.languageCode;
}

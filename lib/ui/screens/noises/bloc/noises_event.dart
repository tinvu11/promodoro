import 'package:equatable/equatable.dart';

import '../../../../data/models/theme_model.dart';

sealed class NoisesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoadNoises extends NoisesEvent {}

final class RefreshNoises extends NoisesEvent {}

final class SaveNoises extends NoisesEvent {}

/// Event khi người dùng chọn 1 theme từ grid.
final class SelectTheme extends NoisesEvent {
  final ThemeModel theme;
  final String languageCode;

  SelectTheme({required this.theme, required this.languageCode});

  @override
  List<Object?> get props => [theme, languageCode];
}

/// Event khởi tạo preview cho theme đang active (khi mở trang).
final class InitPreview extends NoisesEvent {
  final String themeId;

  InitPreview({required this.themeId});

  @override
  List<Object?> get props => [themeId];
}

/// Event toggle play/pause audio preview.
final class TogglePreviewAudio extends NoisesEvent {}

/// Event dừng hoàn toàn preview (khi rời trang).
final class StopPreview extends NoisesEvent {}

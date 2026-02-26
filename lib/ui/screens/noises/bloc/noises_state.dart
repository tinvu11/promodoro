import 'package:equatable/equatable.dart';

import '../../../../data/models/theme_model.dart';

enum NoiseStatus { initial, loading, success, error }

/// Trạng thái tải theme (ảnh + audio) về local.
enum ThemeDownloadStatus { idle, downloading, downloaded, failed }

class NoisesState extends Equatable {
  final NoiseStatus status;
  final List<ThemeModel> themes;
  final String? errorMessage;
  final ThemeDownloadStatus downloadStatus;
  final String? downloadingThemeId;
  final String pathTheme;

  /// Tập ID các theme đã tải về local.
  final Set<String> downloadedThemeIds;

  /// Đường dẫn ảnh nền đang preview (hiển thị trên ThemeBackground).
  final String? previewBgPath;

  /// Theme ID đang preview.
  final String? previewThemeId;

  /// Trạng thái audio preview đang phát hay không.
  final bool isAudioPlaying;

  final String themeName;

  const NoisesState({
    this.status = NoiseStatus.initial,
    this.themes = const [],
    this.errorMessage,
    this.downloadStatus = ThemeDownloadStatus.idle,
    this.downloadingThemeId,
    this.downloadedThemeIds = const {},
    this.pathTheme = "",
    this.previewBgPath,
    this.previewThemeId,
    this.isAudioPlaying = false,
    this.themeName = "",
  });

  @override
  List<Object?> get props => [
    status,
    themes,
    errorMessage,
    downloadStatus,
    downloadingThemeId,
    downloadedThemeIds,
    previewBgPath,
    previewThemeId,
    isAudioPlaying,
    themeName,
  ];

  NoisesState copyWith({
    NoiseStatus? status,
    List<ThemeModel>? themes,
    String? errorMessage,
    ThemeDownloadStatus? downloadStatus,
    String? downloadingThemeId,
    Set<String>? downloadedThemeIds,
    String? previewBgPath,
    String? previewThemeId,
    bool? isAudioPlaying,
    String? themeName,
  }) {
    return NoisesState(
      status: status ?? this.status,
      themes: themes ?? this.themes,
      errorMessage: errorMessage ?? this.errorMessage,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadingThemeId: downloadingThemeId ?? this.downloadingThemeId,
      downloadedThemeIds: downloadedThemeIds ?? this.downloadedThemeIds,
      previewBgPath: previewBgPath ?? this.previewBgPath,
      previewThemeId: previewThemeId ?? this.previewThemeId,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      themeName: themeName ?? this.themeName,
    );
  }
}

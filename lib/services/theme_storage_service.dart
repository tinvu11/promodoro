import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/theme_model.dart';

/// Manages offline-first theme assets (background + ambient audio) on disk.
class ThemeStorageService {
  static const String _themeDir = 'theme';
  static const String _bgFile = 'bg.webp';
  static const String _audioFile = 'audio.mp3';

  /// Built-in fallback theme loaded from assets instead of local files.
  static const String defaultThemeId = 'AUCQ2WR0c8WyL2jeC7ri';
  static const String defaultBgAsset = 'assets/images/wave_default_bg.webp';
  static const String defaultAudioAsset =
      'assets/noises/wave_default_audio.ogg';
  static const Map<String, String> defaultThemeNames = {
    "vi": "Sóng Biển",
    "en": "Ocean Waves",
    "es": "Olas",
    "fr": "Vagues",
    "ja": "波",
    "ko": "파도",
    "de": "Wellen",
    "it": "Onde",
    "ru": "Волны",
    "pt": "Ondas",
    "zh": "海浪",
    "hi": "लहरें",
    "ar": "أمواج البحر",
    "id": "Ombak Laut",
    "tr": "Dalgalar",
    "sv": "Havsvågor",
    "nl": "Zeegolven",
  };
  static String getDefaultThemeName(String languageCode) {
    return defaultThemeNames[languageCode] ?? defaultThemeNames['en']!;
  }

  /// Returns true when [themeId] points to built-in default theme.
  static bool isDefaultTheme(String themeId) => themeId == defaultThemeId;

  final Dio _dio;
  String? _cachedRootPath;

  ThemeStorageService({required Dio dio}) : _dio = dio;

  /// Prepares root cache directory for synchronous path access.
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cachedRootPath = '${appDir.path}/$_themeDir';
    final dir = Directory(_cachedRootPath!);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Returns local background path synchronously; null before [init].
  String? bgPathOfSync(String themeId) {
    if (_cachedRootPath == null) return null;
    return '$_cachedRootPath/$themeId/$_bgFile';
  }

  Future<Directory> _getThemeRootDir() async {
    if (_cachedRootPath != null) {
      return Directory(_cachedRootPath!);
    }
    final appDir = await getApplicationDocumentsDirectory();
    _cachedRootPath = '${appDir.path}/$_themeDir';
    final themeDir = Directory(_cachedRootPath!);
    if (!await themeDir.exists()) {
      await themeDir.create(recursive: true);
      log('[ThemeStorage] Created theme root: ${themeDir.path}');
    }
    return themeDir;
  }

  /// Returns dedicated local directory for [themeId].
  Future<Directory> _getThemeDir(String themeId) async {
    final root = await _getThemeRootDir();
    final dir = Directory('${root.path}/$themeId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Returns local background file path for [themeId].
  Future<String> bgPathOf(String themeId) async {
    final dir = await _getThemeDir(themeId);
    return '${dir.path}/$_bgFile';
  }

  /// Returns local audio file path for [themeId].
  Future<String> audioPathOf(String themeId) async {
    final dir = await _getThemeDir(themeId);
    return '${dir.path}/$_audioFile';
  }

  /// Returns true when both background and audio are available locally.
  Future<bool> isThemeDownloaded(String themeId) async {
    final bg = File(await bgPathOf(themeId));
    final audio = File(await audioPathOf(themeId));
    return await bg.exists() && await audio.exists();
  }

  /// Returns true when local background exists for [themeId].
  Future<bool> hasLocalBg(String themeId) async {
    return await File(await bgPathOf(themeId)).exists();
  }

  /// Returns true when local audio exists for [themeId].
  Future<bool> hasLocalAudio(String themeId) async {
    return await File(await audioPathOf(themeId)).exists();
  }

  /// Returns all downloaded theme IDs with complete asset sets.
  Future<Set<String>> getDownloadedThemeIds() async {
    final root = await _getThemeRootDir();
    final Set<String> ids = {};

    if (!await root.exists()) return ids;

    await for (final entity in root.list()) {
      if (entity is Directory) {
        final themeId = entity.path.split(Platform.pathSeparator).last;
        final bg = File('${entity.path}/$_bgFile');
        final audio = File('${entity.path}/$_audioFile');
        if (await bg.exists() && await audio.exists()) {
          ids.add(themeId);
        }
      }
    }
    log('[ThemeStorage] Downloaded themes: $ids');
    return ids;
  }

  /// Tracks in-flight downloads to avoid duplicate requests per theme.
  final Set<String> _downloadingThemes = {};

  Future<bool> downloadAndSaveTheme(
    ThemeModel theme, {
    Function(double)? onProgress,
  }) async {
    if (_downloadingThemes.contains(theme.id)) return false;
    if (await isThemeDownloaded(theme.id)) return true;

    final dir = await _getThemeDir(theme.id);
    final bgPath = '${dir.path}/$_bgFile';
    final audioPath = '${dir.path}/$_audioFile';
    final bgTmpPath = '$bgPath.tmp';
    final audioTmpPath = '$audioPath.tmp';
    try {
      _downloadingThemes.add(theme.id);

      await Future.wait([
        _downloadFile(theme.imageUrl, bgTmpPath),
        _downloadFile(theme.audioUrl, audioTmpPath),
      ]);

      await _safeRename(bgTmpPath, bgPath);
      await _safeRename(audioTmpPath, audioPath);

      return true;
    } catch (e, stack) {
      log('Error downloading theme $theme.id', error: e, stackTrace: stack);

      await _deleteIfExists('${dir.path}/$_bgFile.tmp');
      await _deleteIfExists('${dir.path}/$_audioFile.tmp');
      return false;
    } finally {
      _downloadingThemes.remove(theme.id);
    }
  }

  Future<void> _downloadFile(String url, String savePath) async {
    await _dio.download(url, savePath);
  }

  /// Promotes temporary file to the final path atomically.
  Future<void> _safeRename(String tmpPath, String finalPath) async {
    final tmpFile = File(tmpPath);
    final finalFile = File(finalPath);

    if (await finalFile.exists()) {
      await finalFile.delete();
    }

    await tmpFile.rename(finalPath);
    log('[ThemeStorage] Renamed temp → final: $finalPath');
  }

  /// Deletes file when it exists (best-effort cleanup).
  Future<void> _deleteIfExists(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        log('[ThemeStorage] Cleaned up: $path');
      }
    } catch (e) {
      log('[ThemeStorage] Failed to clean up: $path', error: e);
    }
  }

  /// Deletes local assets for [themeId].
  Future<void> deleteTheme(String themeId) async {
    final dir = await _getThemeDir(themeId);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      log('[ThemeStorage] Deleted theme: $themeId');
    }
  }

  /// Deletes all downloaded theme assets.
  Future<void> clearAllThemes() async {
    final root = await _getThemeRootDir();
    if (await root.exists()) {
      await root.delete(recursive: true);
      log('[ThemeStorage] All themes cleared.');
    }
  }
}

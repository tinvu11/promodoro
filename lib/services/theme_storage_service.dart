import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/theme_model.dart';

/// Service quản lý tải và lưu trữ theme (ảnh nền + audio) theo chiến lược
/// Offline-first & Multi-theme cache.
///
/// File layout trong ApplicationDocumentsDirectory:
///   theme/{themeId}/bg.webp       ← ảnh nền
///   theme/{themeId}/audio.mp3     ← nhạc nền
///   theme/{themeId}/bg.webp.tmp   ← file tạm khi đang tải ảnh
///   theme/{themeId}/audio.mp3.tmp ← file tạm khi đang tải nhạc
///
/// Mỗi theme được lưu trong thư mục riêng, không bị xóa khi chuyển theme.
class ThemeStorageService {
  static const String _themeDir = 'theme';
  static const String _bgFile = 'bg.webp';
  static const String _audioFile = 'audio.mp3';

  /// ID theme mặc định (dùng asset thay vì file tải về).
  static const String defaultThemeId = 'G7GDaHv9v6A21I4v2NQU';
  static const String defaultBgAsset = 'assets/images/tree.jpg';
  static const String defaultAudioAsset = 'noises/bird.ogg';
  static const String defaultThemeName = 'Chim';

  /// Kiểm tra có phải theme mặc định (dùng asset) hay không.
  static bool isDefaultTheme(String themeId) => themeId == defaultThemeId;

  final Dio _dio;
  String? _cachedRootPath;

  ThemeStorageService({required Dio dio}) : _dio = dio;

  /// Pre-cache đường dẫn thư mục app để các method sync hoạt động.
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cachedRootPath = '${appDir.path}/$_themeDir';
    final dir = Directory(_cachedRootPath!);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Lấy đường dẫn ảnh nền **đồng bộ** (trả null nếu chưa init).
  String? bgPathOfSync(String themeId) {
    if (_cachedRootPath == null) return null;
    return '$_cachedRootPath/$themeId/$_bgFile';
  }

  // ──────────────────────────── Paths ────────────────────────────

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

  /// Lấy thư mục riêng cho 1 theme theo [themeId].
  Future<Directory> _getThemeDir(String themeId) async {
    final root = await _getThemeRootDir();
    final dir = Directory('${root.path}/$themeId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Đường dẫn ảnh nền của theme [themeId].
  Future<String> bgPathOf(String themeId) async {
    final dir = await _getThemeDir(themeId);
    return '${dir.path}/$_bgFile';
  }

  /// Đường dẫn audio của theme [themeId].
  Future<String> audioPathOf(String themeId) async {
    final dir = await _getThemeDir(themeId);
    return '${dir.path}/$_audioFile';
  }

  // ──────────────────────── Check tồn tại ────────────────────────

  /// Kiểm tra theme [themeId] đã được tải về chưa (cả ảnh + audio).
  Future<bool> isThemeDownloaded(String themeId) async {
    final bg = File(await bgPathOf(themeId));
    final audio = File(await audioPathOf(themeId));
    return await bg.exists() && await audio.exists();
  }

  /// Kiểm tra xem có ảnh nền local cho theme [themeId] không.
  Future<bool> hasLocalBg(String themeId) async {
    return await File(await bgPathOf(themeId)).exists();
  }

  /// Kiểm tra xem có audio local cho theme [themeId] không.
  Future<bool> hasLocalAudio(String themeId) async {
    return await File(await audioPathOf(themeId)).exists();
  }

  /// Lấy danh sách ID các theme đã tải.
  Future<Set<String>> getDownloadedThemeIds() async {
    final root = await _getThemeRootDir();
    final Set<String> ids = {};

    if (!await root.exists()) return ids;

    await for (final entity in root.list()) {
      if (entity is Directory) {
        final themeId = entity.path.split(Platform.pathSeparator).last;
        // Chỉ đếm nếu cả 2 file đều tồn tại
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

  // ──────────────────── Tải & lưu theme mới ──────────────────────

  /// Tải theme (ảnh + audio) từ [ThemeModel] vào thư mục riêng.
  ///
  /// Nếu theme đã tải rồi → skip, trả về `true` luôn.
  ///
  /// Flow an toàn:
  ///   1. Tải ảnh vào file `.tmp`
  ///   2. Tải audio vào file `.tmp`
  ///   3. Nếu cả 2 thành công → rename `.tmp` → file chính
  ///   4. Nếu bất kỳ bước nào lỗi → xóa file `.tmp`
  // Thêm biến này vào class để tracking các theme đang được tải
  final Set<String> _downloadingThemes = {};

  Future<bool> downloadAndSaveTheme(
    ThemeModel theme, {
    Function(double)? onProgress,
  }) async {
    // 1. Check nếu đang tải hoặc đã tải xong
    if (_downloadingThemes.contains(theme.id)) return false;
    if (await isThemeDownloaded(theme.id)) return true;

    final dir = await _getThemeDir(theme.id);
    final bgPath = '${dir.path}/$_bgFile';
    final audioPath = '${dir.path}/$_audioFile';
    final bgTmpPath = '$bgPath.tmp';
    final audioTmpPath = '$audioPath.tmp';
    try {
      _downloadingThemes.add(theme.id); // Mark as downloading

      // 2. Chạy song song cả 2 tác vụ tải
      await Future.wait([
        _downloadFile(theme.imageUrl, bgTmpPath),
        _downloadFile(theme.audioUrl, audioTmpPath),
      ]);

      // 3. Rename cả 2 file sau khi tải xong cả 2
      // final bgPath = '${dir.path}/$_bgFile';
      // final audioPath = '${dir.path}/$_audioFile';

      await _safeRename(bgTmpPath, bgPath);
      await _safeRename(audioTmpPath, audioPath);

      return true;
    } catch (e, stack) {
      log('Error downloading theme $theme.id', error: e, stackTrace: stack);

      // Cleanup nếu lỗi
      await _deleteIfExists('${dir.path}/$_bgFile.tmp');
      await _deleteIfExists('${dir.path}/$_audioFile.tmp');
      return false;
    } finally {
      _downloadingThemes.remove(theme.id); // Release lock
    }
  }

  // Tách hàm tải nhỏ ra cho gọn
  Future<void> _downloadFile(String url, String savePath) async {
    await _dio.download(url, savePath);
  }

  /// Rename file tạm thành file chính thức.
  Future<void> _safeRename(String tmpPath, String finalPath) async {
    final tmpFile = File(tmpPath);
    final finalFile = File(finalPath);

    // Xóa file cũ nếu tồn tại (trường hợp tải lại theme bị hỏng)
    if (await finalFile.exists()) {
      await finalFile.delete();
    }

    await tmpFile.rename(finalPath);
    log('[ThemeStorage] Renamed temp → final: $finalPath');
  }

  /// Xóa file nếu tồn tại (dùng khi cleanup sau lỗi).
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

  // ────────────────────── Xóa theme ──────────────────────

  /// Xóa 1 theme đã tải theo [themeId].
  Future<void> deleteTheme(String themeId) async {
    final dir = await _getThemeDir(themeId);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      log('[ThemeStorage] Deleted theme: $themeId');
    }
  }

  /// Xóa toàn bộ theme cache.
  Future<void> clearAllThemes() async {
    final root = await _getThemeRootDir();
    if (await root.exists()) {
      await root.delete(recursive: true);
      log('[ThemeStorage] All themes cleared.');
    }
  }
}

import 'dart:developer';

import '../data_sources/local_data.dart';
import '../data_sources/remote_data.dart';
import '../models/theme_model.dart';

abstract interface class RemoteDataRepo {
  Future<List<ThemeModel>> getResources();
}

class RemoteDataRepoImpl implements RemoteDataRepo {
  final RemoteData _remoteData;
  final LocalData _localData;

  const RemoteDataRepoImpl({
    required RemoteData remoteData,
    required LocalData localData,
  }) : _remoteData = remoteData,
       _localData = localData;

  /// Cache-first strategy:
  /// 1. Trả về cache ngay nếu có → UI hiển thị tức thì
  /// 2. Fetch Firebase nền, cập nhật cache
  /// 3. Nếu không có cache → fetch Firebase trực tiếp
  @override
  Future<List<ThemeModel>> getResources() async {
    final cached = _localData.getCachedThemes();

    if (cached.isNotEmpty) {
      // Có cache → trả về ngay, đồng bộ Firebase nền
      _syncFromRemote();
      return cached;
    }

    // Không có cache → phải fetch từ Firebase
    final remoteData = await _remoteData.getResources();
    if (remoteData.isNotEmpty) {
      await _localData.cacheThemes(remoteData);
    }
    return remoteData;
  }

  /// Đồng bộ dữ liệu từ Firebase về cache (chạy nền, không block UI)
  Future<void> _syncFromRemote() async {
    try {
      final remoteData = await _remoteData.getResources();
      if (remoteData.isNotEmpty) {
        await _localData.cacheThemes(remoteData);
      }
    } catch (e) {
      log('Background sync failed', error: e, name: 'RemoteDataRepo');
    }
  }
}

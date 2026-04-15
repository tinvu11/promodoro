import 'dart:developer';

import '../data_sources/local_data.dart';
import '../data_sources/remote_data.dart';
import '../models/theme_model.dart';

abstract interface class RemoteDataRepo {
  Future<List<ThemeModel>> getResources();
  Future<List<ThemeModel>> fetchLatestResources();
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
  /// returns local data immediately when available, otherwise fetches remotely.
  @override
  Future<List<ThemeModel>> getResources() async {
    final cached = _localData.getCachedThemes();

    if (cached.isNotEmpty) {
      return cached;
    }

    return fetchLatestResources();
  }

  /// Fetches latest resources from remote and refreshes local cache.
  @override
  Future<List<ThemeModel>> fetchLatestResources() async {
    try {
      final remoteData = await _remoteData.getResources();
      if (remoteData.isNotEmpty) {
        await _localData.cacheThemes(remoteData);
      }
      return remoteData;
    } catch (e) {
      log(
        'Fetch latest failed, falling back to cache',
        error: e,
        name: 'RemoteDataRepo',
      );
      final cached = _localData.getCachedThemes();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

abstract class RadarPreferencesLocalDataSource {
  Future<bool> isHeadingRotationEnabled();
  Future<void> setHeadingRotationEnabled(bool enabled);
  Future<int> getMapTileCacheMaxSizeBytes();
  Future<void> setMapTileCacheMaxSizeBytes(int bytes);
}

class RadarPreferencesLocalDataSourceImpl
    implements RadarPreferencesLocalDataSource {
  static const String _headingRotationEnabledKey =
      'exploration_radar_heading_rotation_enabled';
  static const String _mapTileCacheMaxSizeBytesKey =
      'exploration_map_tile_cache_max_size_bytes';
  static const int _defaultMapTileCacheMaxSizeBytes = 80 * 1024 * 1024;

  final SharedPreferences sharedPreferences;

  RadarPreferencesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isHeadingRotationEnabled() async {
    try {
      return sharedPreferences.getBool(_headingRotationEnabledKey) ?? false;
    } catch (e) {
      throw CacheException('Failed to read radar rotation preference: $e');
    }
  }

  @override
  Future<void> setHeadingRotationEnabled(bool enabled) async {
    try {
      await sharedPreferences.setBool(_headingRotationEnabledKey, enabled);
    } catch (e) {
      throw CacheException('Failed to store radar rotation preference: $e');
    }
  }

  @override
  Future<int> getMapTileCacheMaxSizeBytes() async {
    try {
      return sharedPreferences.getInt(_mapTileCacheMaxSizeBytesKey) ??
          _defaultMapTileCacheMaxSizeBytes;
    } catch (e) {
      throw CacheException('Failed to read map tile cache size preference: $e');
    }
  }

  @override
  Future<void> setMapTileCacheMaxSizeBytes(int bytes) async {
    try {
      await sharedPreferences.setInt(_mapTileCacheMaxSizeBytesKey, bytes);
    } catch (e) {
      throw CacheException(
        'Failed to store map tile cache size preference: $e',
      );
    }
  }
}

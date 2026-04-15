import 'package:shared_preferences/shared_preferences.dart';

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
    return sharedPreferences.getBool(_headingRotationEnabledKey) ?? false;
  }

  @override
  Future<void> setHeadingRotationEnabled(bool enabled) async {
    await sharedPreferences.setBool(_headingRotationEnabledKey, enabled);
  }

  @override
  Future<int> getMapTileCacheMaxSizeBytes() async {
    return sharedPreferences.getInt(_mapTileCacheMaxSizeBytesKey) ??
        _defaultMapTileCacheMaxSizeBytes;
  }

  @override
  Future<void> setMapTileCacheMaxSizeBytes(int bytes) async {
    await sharedPreferences.setInt(_mapTileCacheMaxSizeBytesKey, bytes);
  }
}

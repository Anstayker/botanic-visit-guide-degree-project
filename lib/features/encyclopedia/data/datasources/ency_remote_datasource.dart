import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../../../core/entities/plant_category.dart';
import '../../../../core/entities/plant_location.dart';
import '../../../../core/errors/exceptions.dart';

abstract class EncyRemoteDataSource {
  Future<List<PlantRemoteRecord>> fetchPlantUpdatesAfterVersion(
    int lastVersion,
  );
}

class EncyRemoteDataSourceImpl implements EncyRemoteDataSource {
  final FirebaseFirestore firestore;

  EncyRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PlantRemoteRecord>> fetchPlantUpdatesAfterVersion(
    int lastVersion,
  ) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection('plants')
          .orderBy('version')
          .limit(500);

      if (lastVersion > 0) {
        query = query.where('version', isGreaterThan: lastVersion);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            final remoteVersion = _readInt(data, 'version');

            if (remoteVersion == null) return null;

            final model = PlantModel(
              id: _readString(data, 'id') ?? doc.id,
              name: _readString(data, 'name') ?? '',
              scientificName:
                  _readString(data, 'scientific_name') ??
                  _readString(data, 'scientificName') ??
                  '',
              ilumination:
                  _readString(data, 'ilumination') ??
                  _readString(data, 'illumination') ??
                  '',
              watering: _readString(data, 'watering') ?? '',
              height: _readString(data, 'height') ?? '',
              growthTime:
                  _readString(data, 'growth_time') ??
                  _readString(data, 'growthTime') ??
                  '',
              minTemperature:
                  _readString(data, 'min_temperature') ??
                  _readString(data, 'minTemperature') ??
                  '',
              maxTemperature:
                  _readString(data, 'max_temperature') ??
                  _readString(data, 'maxTemperature') ??
                  '',
              image: _readString(data, 'image') ?? '',
              description: _readString(data, 'description') ?? '',
              categoryId: PlantCategory.fromId(
                _readInt(data, 'category_id') ?? 1,
              ).id,
              shortDescription:
                  _readString(data, 'short_description') ??
                  _readString(data, 'shortDescription') ??
                  '',
              isDiscovered: false,
              plantLocation: PlantLocation(
                latitude: _readDouble(data, 'latitude') ?? 0,
                longitude: _readDouble(data, 'longitude') ?? 0,
              ),
            );

            return PlantRemoteRecord(model: model, version: remoteVersion);
          })
          .whereType<PlantRemoteRecord>()
          .toList(growable: false);
    } catch (_) {
      throw UnknownException();
    }
  }

  String? _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    return value.toString();
  }

  int? _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  double? _readDouble(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class PlantRemoteRecord {
  final PlantModel model;
  final int version;

  const PlantRemoteRecord({required this.model, required this.version});
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../../../core/entities/plant_category.dart';
import '../../../../core/entities/plant_location.dart';
import '../../../../core/errors/exceptions.dart';

abstract class EncyRemoteDataSource {
  Future<int?> fetchLatestRemoteVersion();
  Future<List<PlantModel>> fetchAllPlants();
}

class EncyRemoteDataSourceImpl implements EncyRemoteDataSource {
  final FirebaseFirestore firestore;

  EncyRemoteDataSourceImpl({required this.firestore});

  @override
  Future<int?> fetchLatestRemoteVersion() async {
    try {
      final snapshot = await firestore
          .collection('metadata')
          .doc('plants_catalog')
          .get();

      if (!snapshot.exists) return null;

      return _readInt(snapshot.data() ?? <String, dynamic>{}, 'version');
    } on FirebaseException catch (e) {
      throw RemoteDataException(
        'Firestore error while reading metadata: ${e.code} - ${e.message}',
      );
    } catch (e) {
      throw UnknownException('Unexpected metadata read error: $e');
    }
  }

  @override
  Future<List<PlantModel>> fetchAllPlants() async {
    try {
      final snapshot = await firestore.collection('plants').get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();

            return PlantModel(
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
              funFact:
                  _readString(data, 'fun_fact') ?? _readString(data, 'funFact'),
              isDiscovered: false,
              plantLocation: PlantLocation(
                latitude: _readDouble(data, 'latitude') ?? 0,
                longitude: _readDouble(data, 'longitude') ?? 0,
              ),
            );
          })
          .toList(growable: false);
    } on FirebaseException catch (e) {
      throw RemoteDataException(
        'Firestore error while fetching plants: ${e.code} - ${e.message}',
      );
    } on TypeError catch (e) {
      throw DataParsingException('Invalid plant payload shape: $e');
    } catch (e) {
      throw UnknownException('Unexpected plants fetch error: $e');
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

import 'package:hive_flutter/adapters.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../../../core/entities/plant.dart';
import '../../../../core/errors/exceptions.dart';

abstract class PlantDetailsLocalDatasource {
  Future<Plant> getPlantDetailsData(String plantId);
}

class PlantDetailsLocalDatasourceImpl implements PlantDetailsLocalDatasource {
  final Box<PlantModel> plantBox;

  PlantDetailsLocalDatasourceImpl({required this.plantBox});

  @override
  Future<Plant> getPlantDetailsData(String plantId) async {
    try {
      final plant = plantBox.get(plantId);
      if (plant != null) {
        return plant.toEntity();
      } else {
        throw const PlantNotFoundException();
      }
    } on PlantNotFoundException {
      rethrow;
    } on HiveError catch (e) {
      throw CacheException('Failed to read plant details from cache: $e');
    } catch (e) {
      throw UnknownException('Failed to retrieve plant details: $e');
    }
  }
}

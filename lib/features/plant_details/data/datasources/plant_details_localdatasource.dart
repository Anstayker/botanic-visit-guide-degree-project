import 'package:hive_flutter/adapters.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../../../core/entities/plant.dart';

abstract class PlantDetailsLocalDatasource {
  Future<Plant> getPlantDetailsData(String plantId);
}

class PlantDetailsLocalDatasourceImpl implements PlantDetailsLocalDatasource {
  final Box<PlantModel> plantBox;

  PlantDetailsLocalDatasourceImpl({required this.plantBox});

  @override
  Future<Plant> getPlantDetailsData(String plantId) {
    try {
      final plant = plantBox.get(plantId);
      if (plant != null) {
        return Future.value(plant.toEntity());
      } else {
        throw Exception('Plant not found');
      }
    } catch (e) {
      throw Exception('Failed to retrieve plant details: $e');
    }
  }
}

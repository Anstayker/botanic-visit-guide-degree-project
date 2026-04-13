import 'package:hive/hive.dart';

import '../../../../core/data/models/plant_model.dart';

abstract class PlantProgressLocalDataSource {
  Future<void> discoverPlant(String plantId);
}

class PlantProgressLocalDatasource implements PlantProgressLocalDataSource {
  final Box<PlantModel> plantBox;

  PlantProgressLocalDatasource({required this.plantBox});

  @override
  Future<void> discoverPlant(String plantId) {
    try {
      final plant = plantBox.get(plantId);
      if (plant == null) {
        throw Exception('Plant not found');
      }

      final updatedPlant = plant.copyWith(isDiscovered: true);
      return plantBox.put(plantId, updatedPlant);
    } catch (e) {
      throw Exception('Failed to unlock plant: $e');
    }
  }
}

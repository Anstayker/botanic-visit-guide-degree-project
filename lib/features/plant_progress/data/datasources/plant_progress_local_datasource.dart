import 'package:hive/hive.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../domain/entities/plant_discovery_progress.dart';

abstract class PlantProgressLocalDataSource {
  Future<void> discoverPlant(String plantId);
  Future<void> setAllPlantsDiscovered(bool isDiscovered);
  Stream<PlantDiscoveryProgress> watchUserProgress();
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

  @override
  Future<void> setAllPlantsDiscovered(bool isDiscovered) async {
    try {
      final updates = <dynamic, PlantModel>{};

      for (final key in plantBox.keys) {
        final plant = plantBox.get(key);
        if (plant == null) {
          continue;
        }

        updates[key] = plant.copyWith(isDiscovered: isDiscovered);
      }

      if (updates.isNotEmpty) {
        await plantBox.putAll(updates);
      }
    } catch (e) {
      throw Exception('Failed to update all discovery states: $e');
    }
  }

  @override
  Stream<PlantDiscoveryProgress> watchUserProgress() async* {
    PlantDiscoveryProgress mapProgress() {
      final totalPlants = plantBox.length;
      final discoveredPlants = plantBox.values
          .where((plant) => plant.isDiscovered)
          .length;

      return PlantDiscoveryProgress(
        totalPlants: totalPlants,
        discoveredPlants: discoveredPlants,
      );
    }

    yield mapProgress();

    await for (final _ in plantBox.watch()) {
      yield mapProgress();
    }
  }
}

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/data/models/plant_model.dart';
import '../datasources/ency_remote_datasource.dart';

abstract class EncyPlantsSyncService {
  Future<void> syncIfNeeded();
}

class EncyPlantsSyncServiceImpl implements EncyPlantsSyncService {
  static const _lastVersionKey = 'ency_plants_last_remote_version';

  final EncyRemoteDataSource remoteDataSource;
  final Box<PlantModel> plantBox;
  final SharedPreferences sharedPreferences;

  EncyPlantsSyncServiceImpl({
    required this.remoteDataSource,
    required this.plantBox,
    required this.sharedPreferences,
  });

  @override
  Future<void> syncIfNeeded() async {
    final lastVersion = sharedPreferences.getInt(_lastVersionKey) ?? 0;

    final latestRemoteVersion = await remoteDataSource
        .fetchLatestRemoteVersion();
    if (latestRemoteVersion == null || latestRemoteVersion == lastVersion) {
      return;
    }

    final remotePlants = await remoteDataSource.fetchAllPlants();
    final remoteIds = remotePlants.map((plant) => plant.id).toSet();
    final localIds = plantBox.keys.map((key) => key.toString()).toSet();

    for (final remotePlant in remotePlants) {
      final existingPlant = plantBox.get(remotePlant.id);

      final mergedPlant = PlantModel(
        id: remotePlant.id,
        name: remotePlant.name,
        scientificName: remotePlant.scientificName,
        ilumination: remotePlant.ilumination,
        watering: remotePlant.watering,
        height: remotePlant.height,
        growthTime: remotePlant.growthTime,
        minTemperature: remotePlant.minTemperature,
        maxTemperature: remotePlant.maxTemperature,
        image: remotePlant.image,
        description: remotePlant.description,
        categoryId: remotePlant.categoryId,
        funFact: remotePlant.funFact,
        plantLocation: remotePlant.plantLocation,
        // Preserve local-only progress data.
        isDiscovered: existingPlant?.isDiscovered ?? false,
      );

      await plantBox.put(mergedPlant.id, mergedPlant);
    }

    for (final localId in localIds.difference(remoteIds)) {
      await plantBox.delete(localId);
    }

    await sharedPreferences.setInt(_lastVersionKey, latestRemoteVersion);
  }
}

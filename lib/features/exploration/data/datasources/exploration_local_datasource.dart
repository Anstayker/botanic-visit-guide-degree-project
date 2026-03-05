import 'package:hive/hive.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../domain/entities/exploration_plant.dart';

abstract class ExplorationLocalDataSource {
  Stream<List<ExplorationPlant>> getExplorationData();
  Future<void> unlockPlant(String plantId);
}

class ExplorationLocalDataSourceImpl extends ExplorationLocalDataSource {
  final Box<PlantModel> plantBox;

  ExplorationLocalDataSourceImpl({required this.plantBox});

  @override
  Stream<List<ExplorationPlant>> getExplorationData() async* {
    List<ExplorationPlant> mapPlants() {
      return plantBox.values
          .map(
            (plantModel) => ExplorationPlant(
              plant: plantModel.toEntity(),
              distance: 0,
              bearing: 0,
              isVisibleInRadar: false,
            ),
          )
          .toList(growable: false);
    }

    yield mapPlants();

    await for (final _ in plantBox.watch()) {
      yield mapPlants();
    }
  }

  @override
  Future<void> unlockPlant(String plantId) {
    // TODO: implement unlockPlant
    throw UnimplementedError();
  }
}

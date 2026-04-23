import 'package:hive/hive.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/exploration_plant.dart';

abstract class ExplorationLocalDataSource {
  Stream<List<ExplorationPlant>> getExplorationData();
}

class ExplorationLocalDataSourceImpl extends ExplorationLocalDataSource {
  final Box<PlantModel> plantBox;

  ExplorationLocalDataSourceImpl({required this.plantBox});

  @override
  Stream<List<ExplorationPlant>> getExplorationData() async* {
    try {
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
    } on HiveError catch (e) {
      throw CacheException('Failed to read exploration plants from cache: $e');
    } on TypeError catch (e) {
      throw DataParsingException('Invalid exploration payload: $e');
    } catch (e) {
      throw UnknownException('Failed to stream exploration plants: $e');
    }
  }
}

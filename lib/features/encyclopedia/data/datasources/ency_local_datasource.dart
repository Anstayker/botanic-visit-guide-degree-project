import '../../domain/entities/ency_plant.dart';

abstract class EncyLocalDatasource {
  Future<List<EncyPlant>> getAllPlants();
  Future<List<EncyPlant>> getPlantsByCategory(int category);
}

class EncyLocalDataSourceImpl implements EncyLocalDatasource {
  @override
  Future<List<EncyPlant>> getAllPlants() {
    // TODO: implement getAllPlants
    throw UnimplementedError();
  }

  @override
  Future<List<EncyPlant>> getPlantsByCategory(int category) {
    // TODO: implement getPlantsByCategory
    throw UnimplementedError();
  }
}

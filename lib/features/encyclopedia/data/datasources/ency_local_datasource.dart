import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/data/models/plant_model.dart';
import '../../domain/entities/ency_plant.dart';
import '../../domain/entities/plant_filter_params.dart';

abstract class EncyLocalDatasource {
  Future<List<EncyPlant>> getAllPlants();
  Future<List<EncyPlant>> getPlantsByCategory(int category);
  Stream<List<Plant>> watchAllPlantsInfo(PlantFilterParams plantFilterParams);
}

class EncyLocalDataSourceImpl implements EncyLocalDatasource {
  final Box<PlantModel> plantBox;

  EncyLocalDataSourceImpl({required this.plantBox});

  @override
  Future<List<EncyPlant>> getAllPlants() async {
    throw UnimplementedError();
  }

  @override
  Future<List<EncyPlant>> getPlantsByCategory(int category) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<Plant>> watchAllPlantsInfo(
    PlantFilterParams plantFilterParams,
  ) async* {
    try {
      List<Plant> applyFilters(List<PlantModel> items) {
        Iterable<PlantModel> filtered = items;

        if (plantFilterParams.categoryId != null) {
          filtered = filtered.where(
            (p) => p.categoryId == plantFilterParams.categoryId!.id,
          );
        }

        if (plantFilterParams.onlyDiscovered == true) {
          filtered = filtered.where((p) => p.isDiscovered);
        }

        if (plantFilterParams.searchQuery != null &&
            plantFilterParams.searchQuery!.isNotEmpty) {
          final query = plantFilterParams.searchQuery!.toLowerCase();
          filtered = filtered.where(
            (p) =>
                p.name.toLowerCase().contains(query) ||
                p.scientificName.toLowerCase().contains(query),
          );
        }

        final filteredList = filtered.toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

        final result = filteredList
            .map((model) => model.toEntity())
            .toList(growable: false);
        return result;
      }

      // Suggestion: Use final allPlants = plantBox.values
      // to avoid multiple calls to plantBox.values and improve readability.

      yield applyFilters(plantBox.values.toList(growable: false));

      await for (final _ in plantBox.watch()) {
        yield applyFilters(plantBox.values.toList(growable: false));
      }
    } catch (e) {
      throw UnknownException();
    }
  }
}

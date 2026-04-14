import 'dart:convert' show json;

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../models/plant_model.dart';

abstract class PlantLocalDataSource {
  Future<void> initializeDataSource();
  Future<List<PlantModel>> getAllPlants();
}

class PlantLocalDataSourceImpl implements PlantLocalDataSource {
  final Box<PlantModel> plantBox;

  PlantLocalDataSourceImpl({required this.plantBox});

  @override
  Future<void> initializeDataSource() async {
    // if (plantBox.isNotEmpty) return;

    final jsonString = await rootBundle.loadString('assets/data/plants.json');
    final List<dynamic> data = json.decode(jsonString);

    final plantsMap = {
      for (final item in data) item['id']: PlantModel.fromJson(item),
    };

    await plantBox.putAll(plantsMap);
  }

  @override
  Future<List<PlantModel>> getAllPlants() async {
    await initializeDataSource();
    return plantBox.values.toList();
  }
}

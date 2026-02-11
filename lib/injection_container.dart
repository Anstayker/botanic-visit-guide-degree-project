import 'package:get_it/get_it.dart' show GetIt;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'core/models/plant_model.dart';
import 'features/encyclopedia/data/datasources/ency_local_datasource.dart';
import 'features/encyclopedia/data/repositories/ency_repository_impl.dart';
import 'features/encyclopedia/domain/repositories/ency_repository.dart';
import 'features/encyclopedia/domain/usecases/ency_get_all_plants.dart';
import 'features/encyclopedia/domain/usecases/ency_get_plants_by_category.dart';
import 'features/encyclopedia/domain/usecases/ency_watch_all_plants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Feature - Encyclopedia
  // Data sources
  sl.registerLazySingleton<EncyLocalDatasource>(
    () => EncyLocalDataSourceImpl(plantBox: sl<Box<PlantModel>>()),
  );

  // Repositories
  sl.registerLazySingleton<EncyRepository>(
    () => EncyRepositoryImpl(localDatasource: sl<EncyLocalDatasource>()),
  );

  // Use cases
  sl.registerLazySingleton<EncyGetAllPlants>(
    () => EncyGetAllPlants(repository: sl<EncyRepository>()),
  );

  sl.registerLazySingleton<EncyGetPlantsByCategory>(
    () => EncyGetPlantsByCategory(repository: sl<EncyRepository>()),
  );

  sl.registerLazySingleton<EncyWatchAllPlants>(
    () => EncyWatchAllPlants(repository: sl<EncyRepository>()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Hive initialization
  await _initHive();
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  // Registrar adapters (generados por hive_generator)
  Hive.registerAdapter(PlantModelAdapter());

  // Abrir boxes
  final plantsBox = await Hive.openBox<PlantModel>('plants');
  sl.registerLazySingleton<Box<PlantModel>>(() => plantsBox);
}

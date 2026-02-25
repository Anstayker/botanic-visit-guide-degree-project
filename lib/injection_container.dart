import 'package:get_it/get_it.dart' show GetIt;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'core/data/datasources/plant_local_data_source.dart';
import 'core/data/models/plant_model.dart';
import 'core/services/location/compass_wrapper.dart';
import 'core/services/location/geolocator_wrapper.dart';
import 'core/services/location/location_service.dart';
import 'features/encyclopedia/data/datasources/ency_local_datasource.dart';
import 'features/encyclopedia/data/repositories/ency_repository_impl.dart';
import 'features/encyclopedia/domain/repositories/ency_repository.dart';
import 'features/encyclopedia/domain/usecases/ency_get_all_plants.dart';
import 'features/encyclopedia/domain/usecases/ency_get_plants_by_category.dart';
import 'features/encyclopedia/domain/usecases/ency_watch_all_plants.dart';
import 'features/exploration/data/datasources/exploration_local_datasource.dart';
import 'features/exploration/data/repositories/exploration_repository_impl.dart';
import 'features/exploration/domain/repositories/exploration_repository.dart';
import 'features/plant_details/data/datasources/plant_details_localdatasource.dart';
import 'features/plant_details/data/repositories/plant_details_repository_impl.dart';
import 'features/plant_details/domain/repositories/plant_details_repository.dart';
import 'features/plant_details/domain/usecases/get_plant_details_data.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton<GeolocatorWrapper>(() => GeolocatorWrapper());
  sl.registerLazySingleton<CompassWrapper>(() => CompassWrapper());
  sl.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(geolocator: sl(), compass: sl()),
  );

  sl.registerLazySingleton<PlantLocalDataSource>(
    () => PlantLocalDataSourceImpl(plantBox: sl<Box<PlantModel>>()),
  );

  //! Feature - Encyclopedia
  // Data sources
  sl.registerLazySingleton<EncyLocalDataSource>(
    () => EncyLocalDataSourceImpl(plantBox: sl<Box<PlantModel>>()),
  );

  // Repositories
  sl.registerLazySingleton<EncyRepository>(
    () => EncyRepositoryImpl(localDatasource: sl<EncyLocalDataSource>()),
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

  //! Feature - Plant Details
  // Data sources
  sl.registerLazySingleton<PlantDetailsLocalDatasource>(
    () => PlantDetailsLocalDatasourceImpl(plantBox: sl<Box<PlantModel>>()),
  );

  // Repositories
  sl.registerLazySingleton<PlantDetailsRepository>(
    () => PlantDetailsRepositoryImpl(
      localDatasource: sl<PlantDetailsLocalDatasource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetPlantDetailsData>(
    () => GetPlantDetailsData(repository: sl<PlantDetailsRepository>()),
  );

  //! Feature - Exploration
  // Data sources
  sl.registerLazySingleton<ExplorationLocalDataSource>(
    () => ExplorationLocalDataSourceImpl(plantBox: sl<Box<PlantModel>>()),
  );

  // Repositories
  sl.registerLazySingleton<ExplorationRepository>(
    () => ExplorationRepositoryImpl(
      localDataSource: sl<ExplorationLocalDataSource>(),
      locationService: sl<LocationService>(),
    ),
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

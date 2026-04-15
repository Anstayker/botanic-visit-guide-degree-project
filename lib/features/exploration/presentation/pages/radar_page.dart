import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/usecases/exploration_watch_nearby_plants.dart';
import '../../domain/usecases/get_map_tile_cache_max_size_bytes.dart';
import '../../domain/usecases/get_exploration_map_regions.dart';
import '../../domain/usecases/get_radar_rotation_enabled.dart';
import '../../domain/usecases/set_radar_rotation_enabled.dart';
import '../../../plant_progress/domain/usecases/discover_plant.dart';
import '../bloc/exploration_bloc.dart';
import '../widgets/radar_page_body.dart';

class RadarPage extends StatelessWidget {
  const RadarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExplorationBloc(
        watchNearbyPlants: sl<ExplorationWatchNearbyPlants>(),
        discoverPlant: sl<DiscoverPlant>(),
        getExplorationMapRegions: sl<GetExplorationMapRegions>(),
        getMapTileCacheMaxSizeBytes: sl<GetMapTileCacheMaxSizeBytes>(),
        getRadarRotationEnabled: sl<GetRadarRotationEnabled>(),
        setRadarRotationEnabled: sl<SetRadarRotationEnabled>(),
        locationService: sl(),
      )..add(ExplorationWatchStarted()),
      child: const RadarPageBody(),
    );
  }
}

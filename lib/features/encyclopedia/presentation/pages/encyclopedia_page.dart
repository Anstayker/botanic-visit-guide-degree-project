import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../plant_progress/domain/usecases/watch_user_progress.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../../domain/usecases/ency_watch_all_plants.dart';
import '../bloc/encyclopedia_bloc.dart';
import '../bloc/user_progress_bloc.dart';
import '../widgets/encyclopedia_widgets.dart';

class EncyclopediaPage extends StatelessWidget {
  const EncyclopediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EncyclopediaBloc(
            watchAllPlants: sl<EncyWatchAllPlants>(),
          )..add(WatchPlantsRequested(filterParams: PlantFilterParams.empty())),
        ),
        BlocProvider(
          create: (_) =>
              UserProgressBloc(watchUserProgress: sl<WatchUserProgress>())
                ..add(const WatchUserProgressRequested()),
        ),
      ],
      child: const SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(child: EncyUserProgressCard()),
          SliverToBoxAdapter(child: EncyFilterChipsWidget()),
          EncyPlantGridWidget(),
        ],
      ),
    );
  }
}

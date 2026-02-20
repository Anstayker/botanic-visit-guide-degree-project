import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../../domain/usecases/ency_watch_all_plants.dart';
import '../bloc/encyclopedia_bloc.dart';
import '../bloc/user_progress_bloc.dart';
import '../widgets/encyclopedia_widgets.dart';

class EncyclopediaPage extends StatelessWidget {
  const EncyclopediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EncyclopediaBloc(watchAllPlants: sl<EncyWatchAllPlants>())
        ..add(WatchPlantsRequested(filterParams: PlantFilterParams.empty())),
      child: BlocProvider(
        create: (_) => UserProgressBloc(),
        child: Column(
          children: const [
            PlantFilterChips(),
            EncyUserProgressCard(),
            EncyFilterChipsWidget(),
            EncyPlantGridWidget(),
          ],
        ),
      ),
    );
  }
}

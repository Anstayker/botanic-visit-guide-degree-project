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
        child: SliverToBoxAdapter(
          child: Column(
            children: const [
              PlantFilterChips(),
              FilterChipsWidget(),
              UserProgressWidget(),
              PlantGridWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  final filterOptions = const [
    'Árboles',
    'Flores',
    'Frutas',
    'Insectos',
    'Aves',
    'Mamíferos',
    'Reptiles',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: filterOptions.map((filter) {
        return FilterChip(
          label: Text(filter),
          onSelected: (selected) {
            context.read<EncyclopediaBloc>().add(
              WatchPlantsRequested(
                filterParams: PlantFilterParams(categoryId: filter),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class UserProgressWidget extends StatelessWidget {
  const UserProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (_, state) {
        if (state is UserProgressLoaded) {
          debugPrint('User progress loaded');
        }
        return SizedBox.shrink();
      },
    );
  }
}

class PlantGridWidget extends StatelessWidget {
  const PlantGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncyclopediaBloc, EncyclopediaState>(
      builder: (context, state) {
        if (state is EncyclopediaLoaded) {
          return Text('data: ${state.plants.length} plants');
        }
        if (state is EncyclopediaLoading) {
          return CircularProgressIndicator();
        }
        if (state is EncyclopediaError) {
          return Text('Error: ${state.message}');
        }
        //! Error Widget

        return Container();
      },
    );
  }
}

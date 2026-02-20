import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/plant_category.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../bloc/encyclopedia_bloc.dart';

class EncyFilterChipsWidget extends StatelessWidget {
  const EncyFilterChipsWidget({super.key});

  final filterOptions = const [
    PlantCategory.frutal,
    PlantCategory.ornamental,
    PlantCategory.medicinal,
    PlantCategory.other,
  ];

  @override
  Widget build(BuildContext context) {
    //? Use SliverPersistentHeader with this widget to make it sticky in the scroll view
    return Wrap(
      children: filterOptions.map((filter) {
        return FilterChip(
          label: Text(filter.name),
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

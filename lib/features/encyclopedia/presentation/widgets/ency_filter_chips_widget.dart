import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/plant_category.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../bloc/encyclopedia_bloc.dart';

class EncyFilterChipsWidget extends StatefulWidget {
  const EncyFilterChipsWidget({super.key});

  @override
  State<EncyFilterChipsWidget> createState() => _EncyFilterChipsWidgetState();
}

class _EncyFilterChipsWidgetState extends State<EncyFilterChipsWidget> {
  static const Color _terracotta = Color(0xFFC26E59);

  PlantCategory? selectedCategory;

  final filterOptions = const [
    PlantCategory.frutal,
    PlantCategory.ornamental,
    PlantCategory.medicinal,
    PlantCategory.other,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          FilterChip(
            label: const Text('Todos'),
            selected: selectedCategory == null,
            labelStyle: TextStyle(
              color: selectedCategory == null ? Colors.white : _terracotta,
              fontWeight: selectedCategory == null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            onSelected: (_) {
              setState(() {
                selectedCategory = null;
              });

              context.read<EncyclopediaBloc>().add(
                WatchPlantsRequested(filterParams: PlantFilterParams.empty()),
              );
            },
          ),
          const SizedBox(width: 8),
          ...filterOptions.map((filter) {
            final isSelected = selectedCategory == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(filter.name),
                selected: isSelected,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : _terracotta,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  setState(() {
                    selectedCategory = filter;
                  });

                  context.read<EncyclopediaBloc>().add(
                    WatchPlantsRequested(
                      filterParams: PlantFilterParams(categoryId: filter),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant_category.dart';

class PlantFilterParams extends Equatable {
  final PlantCategory? categoryId;
  final bool? onlyDiscovered;
  final String? searchQuery;

  const PlantFilterParams({
    this.categoryId,
    this.onlyDiscovered,
    this.searchQuery,
  });

  factory PlantFilterParams.empty() => const PlantFilterParams();

  @override
  List<Object?> get props => [categoryId, onlyDiscovered, searchQuery];
}

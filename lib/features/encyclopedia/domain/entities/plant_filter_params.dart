import 'package:equatable/equatable.dart';

class PlantFilterParams extends Equatable {
  final String? categoryId;
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

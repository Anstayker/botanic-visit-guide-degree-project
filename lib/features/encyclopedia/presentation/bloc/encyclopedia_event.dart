part of 'encyclopedia_bloc.dart';

sealed class EncyclopediaEvent extends Equatable {
  const EncyclopediaEvent();

  @override
  List<Object> get props => [];
}

final class WatchPlantsRequested extends EncyclopediaEvent {
  final PlantFilterParams filterParams;

  const WatchPlantsRequested({required this.filterParams});

  @override
  List<Object> get props => [filterParams];
}

final class WatchPlantsStopped extends EncyclopediaEvent {
  const WatchPlantsStopped();
}

final class _PlantsUpdated extends EncyclopediaEvent {
  final List<Plant> plants;

  const _PlantsUpdated(this.plants);

  @override
  List<Object> get props => [plants];
}

final class _PlantsFailed extends EncyclopediaEvent {
  final String message;

  const _PlantsFailed(this.message);

  @override
  List<Object> get props => [message];
}

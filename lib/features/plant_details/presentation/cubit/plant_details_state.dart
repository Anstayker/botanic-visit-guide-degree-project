part of 'plant_details_cubit.dart';

sealed class PlantDetailsState extends Equatable {
  const PlantDetailsState();

  @override
  List<Object> get props => [];
}

final class PlantDetailsInitial extends PlantDetailsState {}

final class PlantDetailsLoading extends PlantDetailsState {}

final class PlantDetailsLoaded extends PlantDetailsState {
  final Plant plantDetails;

  const PlantDetailsLoaded({required this.plantDetails});

  @override
  List<Object> get props => [plantDetails];
}

final class PlantDetailsError extends PlantDetailsState {
  final String message;

  const PlantDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

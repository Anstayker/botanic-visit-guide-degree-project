part of 'user_progress_bloc.dart';

sealed class UserProgressState extends Equatable {
  const UserProgressState();

  @override
  List<Object> get props => [];
}

final class UserProgressInitial extends UserProgressState {}

final class UserProgressLoading extends UserProgressState {}

final class UserProgressLoaded extends UserProgressState {
  final int totalPlants;
  final int identifiedPlants;
  final int progressPercentage;
  final double progressValue;
  final int levelNumber;
  final String levelTitle;

  const UserProgressLoaded({
    required this.totalPlants,
    required this.identifiedPlants,
    required this.progressPercentage,
    required this.progressValue,
    required this.levelNumber,
    required this.levelTitle,
  });

  @override
  List<Object> get props => [
    totalPlants,
    identifiedPlants,
    progressPercentage,
    progressValue,
    levelNumber,
    levelTitle,
  ];
}

final class UserProgressError extends UserProgressState {
  final String message;

  const UserProgressError({required this.message});

  @override
  List<Object> get props => [message];
}

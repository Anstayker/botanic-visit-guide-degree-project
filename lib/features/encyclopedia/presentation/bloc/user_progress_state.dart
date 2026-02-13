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

  const UserProgressLoaded({
    required this.totalPlants,
    required this.identifiedPlants,
    required this.progressPercentage,
  });

  @override
  List<Object> get props => [totalPlants, identifiedPlants];
}

final class UserProgressError extends UserProgressState {
  final String message;

  const UserProgressError({required this.message});

  @override
  List<Object> get props => [message];
}

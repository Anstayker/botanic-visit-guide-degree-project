part of 'encyclopedia_bloc.dart';

sealed class EncyclopediaState extends Equatable {
  const EncyclopediaState();

  @override
  List<Object> get props => [];
}

final class EncyclopediaInitial extends EncyclopediaState {}

final class EncyclopediaLoading extends EncyclopediaState {}

final class EncyclopediaLoaded extends EncyclopediaState {
  final List<Plant> plants;

  const EncyclopediaLoaded({required this.plants});

  @override
  List<Object> get props => [plants];
}

final class EncyclopediaError extends EncyclopediaState {
  final String message;

  const EncyclopediaError({required this.message});

  @override
  List<Object> get props => [message];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/stream_usecase.dart';
import '../../../plant_progress/domain/entities/plant_discovery_progress.dart';
import '../../../plant_progress/domain/usecases/watch_user_progress.dart';

part 'user_progress_event.dart';
part 'user_progress_state.dart';

class UserProgressBloc extends Bloc<UserProgressEvent, UserProgressState> {
  final WatchUserProgress watchUserProgress;
  StreamSubscription? _progressSubscription;

  UserProgressBloc({required this.watchUserProgress})
    : super(UserProgressInitial()) {
    on<WatchUserProgressRequested>(_onWatchRequested);
    on<WatchUserProgressStopped>(_onWatchStopped);
    on<_UserProgressUpdated>(_onProgressUpdated);
    on<_UserProgressFailed>(_onProgressFailed);
  }

  Future<void> _onWatchRequested(
    WatchUserProgressRequested event,
    Emitter<UserProgressState> emit,
  ) async {
    emit(UserProgressLoading());

    await _progressSubscription?.cancel();

    _progressSubscription = watchUserProgress(NoParams()).listen((result) {
      result.fold(
        (failure) => add(_UserProgressFailed(failure.message)),
        (progress) => add(_UserProgressUpdated(progress)),
      );
    });
  }

  Future<void> _onWatchStopped(
    WatchUserProgressStopped event,
    Emitter<UserProgressState> emit,
  ) async {
    await _progressSubscription?.cancel();
    _progressSubscription = null;
    emit(UserProgressInitial());
  }

  void _onProgressUpdated(
    _UserProgressUpdated event,
    Emitter<UserProgressState> emit,
  ) {
    final level = _levelForPercentage(event.progress.progressPercentage);

    emit(
      UserProgressLoaded(
        totalPlants: event.progress.totalPlants,
        identifiedPlants: event.progress.discoveredPlants,
        progressPercentage: event.progress.progressPercentage,
        progressValue: event.progress.progressValue,
        levelNumber: level.$1,
        levelTitle: level.$2,
      ),
    );
  }

  void _onProgressFailed(
    _UserProgressFailed event,
    Emitter<UserProgressState> emit,
  ) {
    emit(UserProgressError(message: event.message));
  }

  (int, String) _levelForPercentage(int percentage) {
    if (percentage >= 100) return (6, 'Maestro Botanico');
    if (percentage >= 80) return (5, 'Guardian del Jardin');
    if (percentage >= 60) return (4, 'Botanico Experto');
    if (percentage >= 40) return (3, 'Descubridor Novato');
    if (percentage >= 20) return (2, 'Observador Verde');
    return (1, 'Explorador Inicial');
  }

  @override
  Future<void> close() async {
    await _progressSubscription?.cancel();
    return super.close();
  }
}

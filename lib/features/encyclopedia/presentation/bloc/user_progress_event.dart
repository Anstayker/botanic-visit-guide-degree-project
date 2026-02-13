part of 'user_progress_bloc.dart';

sealed class UserProgressEvent extends Equatable {
  const UserProgressEvent();

  @override
  List<Object> get props => [];
}

final class WatchUserProgressRequested extends UserProgressEvent {
  const WatchUserProgressRequested();
}

final class WatchUserProgressStopped extends UserProgressEvent {
  const WatchUserProgressStopped();
}

final class _UserProgressUpdated extends UserProgressEvent {
  // final UserProgress progress;

  // const _UserProgressUpdated(this.progress);

  // @override
  // List<Object> get props => [progress];
}

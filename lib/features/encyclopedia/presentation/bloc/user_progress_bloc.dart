import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_progress_event.dart';
part 'user_progress_state.dart';

class UserProgressBloc extends Bloc<UserProgressEvent, UserProgressState> {
  UserProgressBloc() : super(UserProgressInitial()) {
    on<UserProgressEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

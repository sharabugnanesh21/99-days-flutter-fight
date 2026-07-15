// ============================================================================
// USER — BLOC
//
// This is the bloc that shows the full async lifecycle:
//
//   UserInitial --add(FetchUsers)--> UserLoading --> UserLoaded(data)
//                                               \--> UserError(message)
//
// Notice the handler is `async` — one event can emit SEVERAL states over time
// (first loading, then the result). That's something a plain setState can't
// express cleanly, and it's the main reason Bloc exists.
//
// The bloc does NOT know about HTTP — it just asks the repository.
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  // Initial state = UserInitial (nothing fetched yet).
  UserBloc(this.repository) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      // 1) Tell the UI we're busy -> it shows a spinner.
      emit(UserLoading());

      try {
        final users = await repository.getUsers(fail: event.simulateError);

        // 2) Success -> hand the data to the UI.
        emit(UserLoaded(users));
      } catch (e) {
        // 3) Failure -> hand the reason to the UI.
        emit(UserError(e.toString()));
      }
    });
  }
}

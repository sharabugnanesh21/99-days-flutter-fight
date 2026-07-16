// ============================================================================
// USER — the Riverpod equivalent of day_98's UserBloc + the 4 states
// (UserInitial / UserLoading / UserLoaded / UserError).
//
// Riverpod's big win here: you don't hand-write those 4 state classes.
// `AsyncValue<T>` is a BUILT-IN type that already models "loading / data /
// error" for you. We model "hasn't been fetched yet" as AsyncData(null).
//
//   AsyncValue<List<String>?>
//     ├─ AsyncLoading()        -> spinner
//     ├─ AsyncData(null)       -> "not fetched yet" (our stand-in for Initial)
//     ├─ AsyncData([...])      -> the loaded list
//     └─ AsyncError(err, st)   -> the error + stack trace
//
// `AsyncValue.guard(...)` replaces the try/catch you wrote by hand in
// UserBloc — it runs the future and automatically turns a thrown error into
// AsyncError. One line instead of a try/catch block.
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/user_repository_provider.dart';

class UserNotifier extends AsyncNotifier<List<String>?> {
  @override
  Future<List<String>?> build() async {
    // Initial state: nothing fetched yet. Unlike a typical AsyncNotifier
    // (which usually fetches immediately in build()), we deliberately return
    // null here so the UI can show an "Initial" prompt until the user taps
    // the button — mirroring UserInitial from day_98.
    return null;
  }

  Future<void> fetchUsers({bool simulateError = false}) async {
    state = const AsyncValue.loading(); // 1) tell the UI: show a spinner

    final repository = ref.read(userRepositoryProvider);

    // 2) success -> AsyncData(users)   3) failure -> AsyncError(e, stack)
    state = await AsyncValue.guard(
      () async => repository.getUsers(fail: simulateError),
    );
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, List<String>?>(
  UserNotifier.new,
);

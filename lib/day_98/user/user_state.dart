// ============================================================================
// USER — STATES  (the 4 classic ones)
//
//   UserInitial  -> nothing has happened yet (app just opened)
//   UserLoading  -> request is in flight     -> show a spinner
//   UserLoaded   -> success + the real data  -> show the list
//   UserError    -> failure + a message      -> show the error
//
// Here the base class is ABSTRACT and each state is a separate subclass.
// That's why the UI uses `if (state is UserLoading)` to decide what to draw.
// ============================================================================

abstract class UserState {}

/// Nothing requested yet.
class UserInitial extends UserState {}

/// Waiting for the repository to answer.
class UserLoading extends UserState {}

/// Success — carries the data.
class UserLoaded extends UserState {
  final List<String> users;

  UserLoaded(this.users);
}

/// Failure — carries the reason.
class UserError extends UserState {
  final String message;

  UserError(this.message);
}

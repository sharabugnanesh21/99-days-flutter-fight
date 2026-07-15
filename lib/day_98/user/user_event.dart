// ============================================================================
// USER — EVENTS
// ============================================================================

abstract class UserEvent {}

/// Ask the bloc to load users from the repository.
/// `simulateError: true` forces the failure path so we can see the error state.
class FetchUsers extends UserEvent {
  final bool simulateError;

  FetchUsers({this.simulateError = false});
}

// ============================================================================
// REPOSITORY — the data layer. Identical role to day_98's version: a plain
// class that knows HOW to get data. Providers/Notifiers depend on this
// instead of talking to a network directly.
// ============================================================================

class UserRepository {
  /// Fake "API call": waits 2 seconds, then returns data — or throws, so we
  /// can demonstrate the error state on demand.
  Future<List<String>> getUsers({bool fail = false}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (fail) {
      throw Exception('Could not reach the server');
    }

    return ['Alice', 'Bob', 'Charlie', 'Diana'];
  }
}

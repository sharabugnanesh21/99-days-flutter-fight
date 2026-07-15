// ============================================================================
// REPOSITORY — the data layer.
//
// A repository is a plain class that knows HOW to get data (API, DB, cache).
// Blocs talk to a repository instead of calling the network directly. That way
// the bloc only cares about "give me users", not about HTTP.
//
// We hand this to the app with RepositoryProvider (see main.dart).
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

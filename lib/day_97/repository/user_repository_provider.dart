// ============================================================================
// REPOSITORY PROVIDER — the Riverpod equivalent of day_98's
// `RepositoryProvider(create: (_) => UserRepository())`.
//
// A plain `Provider` exposes a value that never changes (no `state =`, no
// notifier methods) — perfect for a repository/service. Anything that needs
// it calls `ref.watch(userRepositoryProvider)` or `ref.read(...)`.
//
// Same payoff as RepositoryProvider in Bloc: ONE shared instance, and
// swappable for a fake in tests (see `❓_my_doubts.md` style notes later).
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// ============================================================================
// TOGGLE — the Riverpod equivalent of day_98's screen-scoped ToggleBloc.
//
// In Bloc, "screen-scoped" meant physically placing BlocProvider INSIDE
// ToggleScreen's widget tree. Riverpod does NOT work that way — every
// provider is a global final variable, always. Scoping instead comes from
// the `.autoDispose` MODIFIER below:
//
//   - `.autoDispose` means: "when NOTHING is watching this provider anymore
//     (e.g. you left ToggleScreen), throw its state away."
//   - Come back later -> `build()` runs again -> fresh state (false/OFF).
//
// This is the direct parallel to "the ToggleBloc's provider was removed from
// the tree, so it got disposed" — same OUTCOME, different MECHANISM.
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleNotifier extends Notifier<bool> {
  @override
  bool build() => false; // initial state = OFF

  void toggle() => state = !state;
}

// `.autoDispose` is what makes this provider SCREEN-SCOPED, not app-wide.
final toggleProvider = NotifierProvider.autoDispose<ToggleNotifier, bool>(
  ToggleNotifier.new,
);


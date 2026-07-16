// ============================================================================
// NAV — the Riverpod equivalent of day_98's NavBloc.
//
// Same pattern: navigation is a SIDE EFFECT, so a button should not navigate
// directly. It calls a method -> the provider's state changes -> a
// `ref.listen` in the UI reacts and navigates. This matters when navigation
// depends on an ASYNC result the notifier computes (e.g. "login succeeded"),
// not just for opening a plain screen (where direct Navigator.push is fine
// and simpler — see home_screen.dart section 8 for both, side by side).
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavSignal { toggleScreen }

class NavNotifier extends Notifier<NavSignal?> {
  @override
  NavSignal? build() => null; // nothing to do right now

  void requestToggleScreen() {
    state = NavSignal.toggleScreen; // 1) fire the "navigate" signal
    state = null; // 2) reset immediately, so tapping again re-triggers it
  }
}

final navProvider = NotifierProvider<NavNotifier, NavSignal?>(NavNotifier.new);

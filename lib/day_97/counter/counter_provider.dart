// ============================================================================
// COUNTER — the Riverpod equivalent of day_98's CounterBloc.
//
// A Notifier<int>:
//   - `build()` returns the INITIAL state (like Bloc's `super(initialState)`).
//   - methods mutate `state` directly (`state = state + 1`) — no `emit()`,
//     no events. This is the big Riverpod simplification over Bloc for
//     synchronous state: no event classes needed, just call a method.
//   - `state` is inherited, exactly like Bloc's `state` getter.
//
// Unlike day_98's CounterState class (count field + copyWith), Riverpod's
// simplest Notifier state can just be a raw value — `int` — when there's only
// one thing to track. No need to wrap it in a class unless it grows fields.
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0; // initial state = 0

  void increment() => state = state + 1;
  void decrement() => state = state - 1;
  void reset() => state = 0;
}

// The PROVIDER — a top-level, app-wide reference to this notifier.
// NOTE: in Riverpod, providers are ALWAYS declared as global final variables
// (unlike Bloc, where placement in the widget tree decided the lifetime).
// This one has NO `.autoDispose`, so it behaves like a Bloc provided ABOVE
// MaterialApp — it lives for the whole app and is shared across every screen.
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);

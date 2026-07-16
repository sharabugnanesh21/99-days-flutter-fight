// ============================================================================
// COUNTER — the Riverpod equivalent of day_98's CounterBloc.
//
// A Notifier<CounterModelState>:
//   - `build()` returns the INITIAL state (like Bloc's `super(initialState)`).
//   - methods mutate `state` directly via copyWith (same pattern as day_98).
//   - The state is wrapped in a class, just like day_98's CounterState.
//
// This is the CLASS-BASED approach, same philosophy as day_98.
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'counter_model_state.dart';

class CounterNotifier extends Notifier<CounterModelState> {
  @override
  CounterModelState build() => CounterModelState(); // initial state

  void increment() =>
      state = state.copyWith(counter: state.counter + 1);
  void decrement() =>
      state = state.copyWith(counter: state.counter - 1);
  void reset() => state = state.copyWith(counter: 0);
}

// The PROVIDER — a top-level, app-wide reference to this notifier.
// NOTE: in Riverpod, providers are ALWAYS declared as global final variables
// (unlike Bloc, where placement in the widget tree decided the lifetime).
// This one has NO `.autoDispose`, so it behaves like a Bloc provided ABOVE
// MaterialApp — it lives for the whole app and is shared across every screen.
final counterProvider =
    NotifierProvider<CounterNotifier, CounterModelState>(
  CounterNotifier.new,
);

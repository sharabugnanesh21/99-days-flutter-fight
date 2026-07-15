// ============================================================================
// COUNTER — STATE
//
// A STATE describes "what the screen should show right now".
// For the counter it's just a number, but we still wrap it in a class because
// that's the pattern you'll use for real features (where state has many fields).
//
// copyWith() = "give me a copy of this state with some fields changed".
// State is IMMUTABLE — you never edit it, you always emit a NEW one.
// ============================================================================

class CounterState {
  final int count;

  const CounterState({this.count = 0});

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }
}

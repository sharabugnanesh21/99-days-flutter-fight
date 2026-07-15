// ============================================================================
// TOGGLE — STATE
//
// Simple on/off state, still wrapped in a class to follow the same pattern.
// ============================================================================

class ToggleState {
  final bool isOn;

  const ToggleState({this.isOn = false});

  ToggleState copyWith({bool? isOn}) {
    return ToggleState(isOn: isOn ?? this.isOn);
  }
}

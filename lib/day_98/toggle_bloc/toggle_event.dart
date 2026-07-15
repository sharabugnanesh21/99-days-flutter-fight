// ============================================================================
// TOGGLE — EVENTS
//
// Only one thing can happen here: the user pressed the toggle button.
// ============================================================================

abstract class ToggleEvent {}

/// User pressed the toggle button.
class TogglePressed extends ToggleEvent {}

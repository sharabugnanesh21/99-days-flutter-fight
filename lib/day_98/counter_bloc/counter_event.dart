// ============================================================================
// COUNTER — EVENTS
//
// An EVENT is "something happened" (the user pressed a button).
// With a Bloc you never call methods on it — you ADD an event:
//     context.read<CounterBloc>().add(IncrementPressed());
//
// The base class is abstract; each real event is a subclass.
// ============================================================================

abstract class CounterEvent {}

/// User pressed "+"
class IncrementPressed extends CounterEvent {}

/// User pressed "-"
class DecrementPressed extends CounterEvent {}

/// User pressed "reset"
class ResetPressed extends CounterEvent {}

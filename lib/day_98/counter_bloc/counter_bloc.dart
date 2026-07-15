// ============================================================================
// COUNTER — BLOC
//
// A BLOC maps EVENTS -> STATES.
//
//   Bloc<CounterEvent, CounterState>
//        ^ what goes IN    ^ what comes OUT
//
// You register one handler per event with `on<EventType>((event, emit) {...})`.
// Inside the handler you call emit(newState) to push a new state to the UI.
//
// Note the difference from a Cubit:
//   Cubit -> you call a method:  cubit.increment()
//   Bloc  -> you add an event:   bloc.add(IncrementPressed())
// The event gives you a record of WHAT happened, which is easier to debug/test.
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // super(...) sets the INITIAL STATE (count = 0).
  CounterBloc() : super(const CounterState()) {
    // Handler for the "+" event.
    on<IncrementPressed>((event, emit) {
      emit(state.copyWith(count: state.count + 1));
    });

    // Handler for the "-" event.
    on<DecrementPressed>((event, emit) {
      emit(state.copyWith(count: state.count - 1));
    });

    // Handler for the "reset" event.
    on<ResetPressed>((event, emit) {
      emit(const CounterState(count: 0));
    });
  }
}

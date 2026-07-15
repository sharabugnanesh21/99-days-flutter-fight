// ============================================================================
// TOGGLE — BLOC
//
// This bloc is used to demonstrate a SCREEN-SCOPED BlocProvider:
// it is created when you open ToggleScreen and disposed when you leave it,
// unlike CounterBloc/UserBloc which live for the whole app.
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import 'toggle_event.dart';
import 'toggle_state.dart';

class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
  // Initial state: OFF.
  ToggleBloc() : super(const ToggleState()) {
    on<TogglePressed>((event, emit) {
      emit(state.copyWith(isOn: !state.isOn));
    });
  }
}

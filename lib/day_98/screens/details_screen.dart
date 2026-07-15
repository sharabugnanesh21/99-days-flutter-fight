// ============================================================================
// DETAILS SCREEN
//
// A second screen reached via Navigator. Its whole point is to prove the
// CounterBloc is SHARED: this screen reads and changes the exact same counter
// as Home, because the bloc was provided ABOVE MaterialApp.
//
// It also demonstrates BlocListener on its own — side effects, no UI building.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../counter_bloc/counter_bloc.dart';
import '../counter_bloc/counter_event.dart';
import '../counter_bloc/counter_state.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),

      // BlocListener — pure SIDE EFFECTS. It builds no UI of its own; it just
      // fires `listener` whenever the state changes. Here: a snackbar on every
      // count change.  (BlocConsumer = BlocListener + BlocBuilder combined.)
      body: BlocListener<CounterBloc, CounterState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Count changed to ${state.count}'),
              duration: const Duration(milliseconds: 600),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Different screen — but the SAME counter:'),
              const SizedBox(height: 8),

              // Same CounterBloc as Home -> reads the shared state.
              BlocBuilder<CounterBloc, CounterState>(
                builder: (context, state) => Text(
                  '${state.count}',
                  style: const TextStyle(fontSize: 48),
                ),
              ),

              ElevatedButton(
                onPressed: () =>
                    context.read<CounterBloc>().add(IncrementPressed()),
                child: const Text('Increment from Details'),
              ),
              const SizedBox(height: 8),
              const Text('Go back — Home shows the updated value.'),
            ],
          ),
        ),
      ),
    );
  }
}

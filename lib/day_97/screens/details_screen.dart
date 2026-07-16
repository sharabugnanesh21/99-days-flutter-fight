// ============================================================================
// DETAILS SCREEN
//
// A second screen reached via Navigator. Its whole point is to prove
// counterProvider is SHARED: this screen reads and changes the exact same
// counter as Home, because the provider is a top-level global variable (not
// something scoped inside a widget) — every screen that watches/reads
// counterProvider is talking to the same single notifier instance.
//
// It also demonstrates ref.listen on its own — side effects, no UI building.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../counter/counter_provider.dart';
import '../counter/counter_model_state.dart';


class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen — pure SIDE EFFECTS, no UI of its own. This is the
    // ref.listen equivalent of day_98's BlocListener-as-the-whole-body
    // pattern: it fires the callback whenever counterProvider's value
    // changes, and here we just pop a snackbar. It must be called directly
    // inside build() (Riverpod registers/unregisters it safely across
    // rebuilds) — never bury navigation/snackbar logic inside .when() or a
    // builder callback, only inside ref.listen.
    ref.listen<CounterModelState>(counterProvider, (previous, next) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Count changed to ${next.counter}'),
          duration: const Duration(milliseconds: 600),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Different screen — but the SAME counter:'),
            const SizedBox(height: 8),

            // Same counterProvider as Home -> reads the shared state.
            // ref.watch subscribes AND builds in one step (no separate
            // "builder widget" needed like BlocBuilder was).
            Text(
              '${ref.watch(counterProvider).counter}',
              style: const TextStyle(fontSize: 48),
            ),

            ElevatedButton(
              onPressed: () =>
                  ref.read(counterProvider.notifier).increment(),
              child: const Text('Increment from Details'),
            ),
            const SizedBox(height: 8),
            const Text('Go back — Home shows the updated value.'),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TOGGLE SCREEN — demonstrates an autoDispose provider, Riverpod-style.
//
// In day_98 (Bloc), scoping a bloc to ONE screen meant wrapping the Scaffold
// in a widget:
//
//     BlocProvider(
//       create: (_) => ToggleBloc(),
//       child: Scaffold( ... ),
//     )
//
// You needed that wrapper because a Bloc has to be PLACED somewhere in the
// widget tree for context.read/watch to find it — and placing it here (not
// in main.dart) is what tied its lifecycle to this screen.
//
// Riverpod does NOT work that way. Every provider — even a screen-scoped one
// — is declared as a single top-level `final` variable (see
// lib/day_97/toggle/toggle_provider.dart), never nested inside a widget's
// build() method. There is no "wrap my Scaffold in a provider" step at all.
//
// So how does this screen still get FRESH state (OFF) every time you arrive?
// The scoping already happened at the DECLARATION site, via one flag:
//
//     NotifierProvider.autoDispose<ToggleNotifier, bool>(ToggleNotifier.new)
//                      ^^^^^^^^^^^^
//
// `.autoDispose` tells Riverpod: "once nobody is watching this provider
// anymore, throw its state away." The moment you navigate off this screen,
// nothing is calling ref.watch(toggleProvider) anymore -> state is discarded.
// Come back -> build() runs again -> false (OFF), same as day_98's proof.
//
// Net effect: SAME OUTCOME as Bloc's screen-scoped BlocProvider, but the
// mechanism moved from "WHERE you place a widget" to "a flag on the
// provider's declaration". This screen below just calls ref.watch/ref.read
// directly — no special wrapper widget needed.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../toggle/toggle_provider.dart';

class ToggleScreen extends ConsumerWidget {
  const ToggleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch = subscribe + rebuild on change. This IS the "builder" —
    // ConsumerWidget's whole build() re-runs when toggleProvider changes,
    // no separate BlocBuilder-equivalent widget needed for a screen this
    // small.
    final isOn = ref.watch(toggleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Toggle (autoDispose provider)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOn ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 90,
              color: isOn ? Colors.amber : Colors.grey,
            ),
            Text(
              isOn ? 'ON' : 'OFF',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              // ref.read(...).notifier -> call a METHOD directly.
              // No event class, no add() — just toggle().
              onPressed: () => ref.read(toggleProvider.notifier).toggle(),
              child: const Text('Toggle'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HOME SCREEN
//
// Each numbered section demonstrates ONE concept. Read top to bottom.
// Everything now uses BLOCS (add an event), never Cubit methods.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../counter_bloc/counter_bloc.dart';
import '../counter_bloc/counter_event.dart';
import '../counter_bloc/counter_state.dart';
import '../user/user_bloc.dart';
import '../user/user_event.dart';
import '../user/user_state.dart';
import 'details_screen.dart';
import 'toggle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Demo — Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // 1) BlocBuilder — rebuilds its child whenever the state changes.
            //    Use it to turn STATE into UI.
            // ================================================================
            const _Title('1) BlocBuilder'),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                // `state` is the CounterState -> read its fields.
                return Text(
                  'Count: ${state.count}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),

            // ================================================================
            // 2) context.read() — get the bloc WITHOUT listening.
            //    Perfect inside callbacks. It does NOT rebuild this widget.
            //    With a Bloc you ADD AN EVENT (not call a method).
            // ================================================================
            const _Title('2) context.read() + add(event)'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<CounterBloc>().add(IncrementPressed()),
                  child: const Text('+'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CounterBloc>().add(DecrementPressed()),
                  child: const Text('-'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CounterBloc>().add(ResetPressed()),
                  child: const Text('reset'),
                ),
              ],
            ),
            const Divider(height: 32),

            // ================================================================
            // 3) context.watch() — like BlocBuilder, but inline in build().
            //    REBUILDS this widget on every state change.
            //    (Wrapped in a Builder so only this bit rebuilds, not the page.)
            // ================================================================
            const _Title('3) context.watch()'),
            Builder(
              builder: (context) {
                final state = context.watch<CounterBloc>().state;
                return Text('Watched count: ${state.count}');
              },
            ),
            const Divider(height: 32),

            // ================================================================
            // 4) context.select() + BlocSelector
            //    Rebuild ONLY when a DERIVED slice changes (here: even/odd).
            //    Tap "+" repeatedly: these two only flip between EVEN and ODD,
            //    they don't rebuild for every single number.
            //
            //    Subtle difference worth remembering:
            //      - context.select's lambda receives the BLOC  (use .state)
            //      - BlocSelector's selector receives the STATE directly
            // ================================================================
            const _Title('4) select / BlocSelector (even-odd)'),
            Builder(
              builder: (context) {
                final isEven = context.select<CounterBloc, bool>(
                  (bloc) => bloc.state.count.isEven,
                );
                return Text('context.select -> ${isEven ? "EVEN" : "ODD"}');
              },
            ),
            BlocSelector<CounterBloc, CounterState, bool>(
              selector: (state) => state.count.isEven,
              builder: (context, ourIsEven) {
                return Text('BlocSelector  -> ${ourIsEven ? "EVEN" : "ODD"}');
              },
            ),
            const Divider(height: 32),

            // ================================================================
            // 5) BlocConsumer — BlocBuilder + BlocListener in ONE widget.
            //      listener = SIDE EFFECTS (snackbar/navigate). Returns nothing.
            //      builder  = the UI for each state.
            //    This is where the 4 states show up: initial/loading/loaded/error
            // ================================================================
            const _Title('5) BlocConsumer (4 states + snackbar)'),
            BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                // Side effects only — no widget returned here.
                if (state is UserLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Loaded ${state.users.length} users ✅'),
                    ),
                  );
                } else if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message} ❌'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                // Turn each state into UI.
                if (state is UserInitial) {
                  return const Text('Press "Fetch users" to load.');
                } else if (state is UserLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.users.map((u) => Text('• $u')).toList(),
                  );
                } else if (state is UserError) {
                  return Text('Something went wrong: ${state.message}');
                }
                return const SizedBox.shrink();
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context.read<UserBloc>().add(FetchUsers()),
                  child: const Text('Fetch users'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context
                      .read<UserBloc>()
                      .add(FetchUsers(simulateError: true)),
                  child: const Text('Fetch (force error)'),
                ),
              ],
            ),
            const Divider(height: 32),

            // ================================================================
            // 6) Navigation with SHARED state.
            //    The blocs are provided ABOVE MaterialApp (main.dart), so the
            //    screens you push see the SAME CounterBloc.
            // ================================================================
            const _Title('6) Navigation (shared bloc state)'),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetailsScreen()),
              ),
              child: const Text('Go to Details (same counter)'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ToggleScreen()),
              ),
              child: const Text('Go to Toggle (screen-scoped BlocProvider)'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tiny helper so the section headings look consistent.
class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

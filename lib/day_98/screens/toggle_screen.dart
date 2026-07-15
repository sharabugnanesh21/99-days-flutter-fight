// ============================================================================
// TOGGLE SCREEN — demonstrates a SCREEN-SCOPED BlocProvider.
//
// CounterBloc and UserBloc live above MaterialApp, so they survive the whole
// app. But some blocs only matter on ONE screen. Then you create the bloc right
// here with BlocProvider: it's created when you enter this screen and
// AUTOMATICALLY DISPOSED when you leave.
//
// Proof: toggle it ON, go back, come in again -> it's OFF. The bloc was thrown
// away. (The counter, by contrast, keeps its value across screens.)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../toggle_bloc/toggle_bloc.dart';
import '../toggle_bloc/toggle_event.dart';
import '../toggle_bloc/toggle_state.dart';

class ToggleScreen extends StatelessWidget {
  const ToggleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider = create ONE bloc and share it with the subtree below.
    // Placed HERE (not in main.dart), so its lifecycle is tied to this screen.
    return BlocProvider(
      create: (_) => ToggleBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Toggle (scoped BlocProvider)')),
        body: Center(
          child: BlocBuilder<ToggleBloc, ToggleState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    size: 90,
                    color: state.isOn ? Colors.amber : Colors.grey,
                  ),
                  Text(
                    state.isOn ? 'ON' : 'OFF',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ToggleBloc>().add(TogglePressed()),
                    child: const Text('Toggle'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

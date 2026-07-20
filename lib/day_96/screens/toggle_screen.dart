import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/toggle.dart';

class ToggleScreen extends StatelessWidget {
  const ToggleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toggle (screen-scoped)')),
      body: Center(
        child: Consumer<Toggle>(
          builder: (context, toggle, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  toggle.isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: 90,
                  color: toggle.isOn ? Colors.amber : Colors.grey,
                ),
                Text(
                  toggle.isOn ? 'ON' : 'OFF',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<Toggle>().toggle(),
                  child: const Text('Toggle'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

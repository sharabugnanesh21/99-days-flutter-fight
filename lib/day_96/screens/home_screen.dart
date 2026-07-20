import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/counter.dart';
import '../notifiers/user.dart';
import 'toggle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 96 — Provider Package')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Counter display
            const Text('1) Counter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text('Count: ${counter.state.count}', style: const TextStyle(fontSize: 24));
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context.read<Counter>().increment(),
                  child: const Text('+'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.read<Counter>().decrement(),
                  child: const Text('-'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.read<Counter>().reset(),
                  child: const Text('reset'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 2) User fetching
            const Text('2) Users (Async)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Consumer<User>(
              builder: (context, user, child) {
                if (user.state.isLoading) {
                  return const CircularProgressIndicator();
                } else if (user.state.error != null) {
                  return Text('Error: ${user.state.error}');
                } else if (user.state.users != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: user.state.users!.map((u) => Text('• $u')).toList(),
                  );
                } else {
                  return const Text('Press "Fetch users" to load');
                }
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context.read<User>().fetchUsers(),
                  child: const Text('Fetch users'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.read<User>().fetchUsers(simulateError: true),
                  child: const Text('Fetch (error)'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 3) Toggle screen navigation
            const Text('3) Navigation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ToggleScreen()),
              ),
              child: const Text('Go to Toggle Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

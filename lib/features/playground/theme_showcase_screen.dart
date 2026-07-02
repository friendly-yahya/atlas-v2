import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atlas_paragliding_v2/core/theme/theme_provider.dart';

class ThemeShowcaseScreen extends ConsumerWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    final isOperator = currentTheme == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOperator ? 'Operator Mode' : 'Client Mode'),
        actions: [
          // The safe, modern Riverpod toggle
          IconButton(
            icon: Icon(isOperator ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text('Typography', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'This is standard body text. Check how it scales and reads against your background colors.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This is standard body text. Check how it scales and reads against your background colors.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This is standard body text. Check how it scales and reads against your background colors.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This is standard body text. Check how it scales and reads against your background colors.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This is standard body text. Check how it scales and reads against your background colors.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Divider(height: 32),
          
          Text('Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Primary Booking Action'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Secondary Action (Cancel)'),
          ),
          const Divider(height: 32),
          
          Text('Input Fields', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const Divider(height: 32),
          
          Text('Surfaces', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Atlas Flight Experience', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Check the card background color, border radius, and elevation shadow here.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
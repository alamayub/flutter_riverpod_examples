import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// simple provider
final currentData = Provider((ref) => DateTime.now());

class Example1Provider extends ConsumerWidget {
  const Example1Provider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Example1 Provider - DateTime'),
      ),
      body: Center(
        child: Text(date.toIso8601String()),
      ),
    );
  }
}
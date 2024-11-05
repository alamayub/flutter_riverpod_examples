import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentData = Provider((ref) => DateTime.now());

class Example1DateTime extends ConsumerWidget {
  const Example1DateTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Example1'),
      ),
      body: Center(
        child: Text(date.toIso8601String()),
      ),
    );
  }
}
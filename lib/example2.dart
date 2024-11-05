import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// state notifier provider
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this ?? other;
    if(shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

void test() {
  final int? x = 1;
  final int y = 1;
  final res = x + y;
  debugPrint(res.toString());
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

final counterProvider = StateNotifierProvider<Counter, int?>((ref) => Counter());
class Example2DateTime extends ConsumerWidget {
  const Example2DateTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example2 '),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            final text = count == null ? 'Press the Button' : 'Counter $count';
            return Text(text);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(), 
        child: Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const names = [
  'Ravi',
  'Akash',
  'Aman',
  'Ruksar',
  'Simran',
  'Saima',
  'Soaib',
  'Sameer',
  'Sahahrukh',
  'Shakeel',
  'Sahil',
  'Salman'
];


final tickerProvider = StreamProvider((ref) => Stream.periodic(
  const Duration(seconds: 1),
  (i) => i +1,
));

final namesProvider = StreamProvider((ref) => ref.watch(tickerProvider.stream).map((x) => names.getRange(0, x)));

class Example4StreamProvider extends ConsumerWidget {
  const Example4StreamProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Example4 Stream Provider - Timer'),
      ),
      body: names.when(
        data: (res) => ListView.builder(
          shrinkWrap: true,
          itemCount: res.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(res.elementAt(i)),
          ),
        ), 
        error:(error, stackTrace) => Center(
          child: Text(error.toString()),
        ), 
        loading: () => Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
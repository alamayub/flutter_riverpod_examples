import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// future provider
enum City { stockholm, paris, tokyo }
typedef WeatherEmoji = String;
Future<WeatherEmoji> getWeather(City city)  async {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stockholm: '🔥',
      City.paris: '🌧️',
      City.tokyo: '💨'
    }[city] ?? '?',
  );
}

final unknownweatherEmojy = '😿';

final currentCityProvider = StateProvider<City?>((ref) => null);
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if(city != null) {
    return getWeather(city);
  }
  return unknownweatherEmojy;
});

class Example3FutureProvider extends ConsumerWidget {
  const Example3FutureProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Example3 Future Provider - Weather'),
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            alignment: Alignment.center,
            child: currentWeather.when(
              data: (data) => Text(data),
              loading: () => CircularProgressIndicator(
                strokeWidth: 2,
              ),
              error:(error, stackTrace) => Text(error.toString()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () => ref.read(currentCityProvider.notifier).state = city,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
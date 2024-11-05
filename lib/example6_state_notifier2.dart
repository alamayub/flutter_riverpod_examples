// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Film {
  final int id;
  final String name;
  final String description;
  final bool isFavourite;
  const Film({
    required this.id,
    required this.name,
    required this.description,
    required this.isFavourite,
  });

  Film copyWith({
    int? id,
    String? name,
    String? description,
    bool? isFavourite,
  }) => Film(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  

  Map<String, dynamic> toMap() => <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'isFavourite': isFavourite,
    };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Film(id: $id, name: $name, description: $description, isFavourite: $isFavourite)';

  @override
  bool operator ==(covariant Film other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.isFavourite == isFavourite;
  }

  @override
  int get hashCode => id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      isFavourite.hashCode;
}

List<Film> allFilms = [
  Film(
    id: 1,
    name: "Inception",
    description: "A mind-bending thriller by Christopher Nolan.",
    isFavourite: false,
  ),
  Film(
    id: 2,
    name: "The Matrix",
    description: "A hacker discovers the world is a simulation.",
    isFavourite: true,
  ),
  Film(
    id: 3,
    name: "Interstellar",
    description: "Exploring space to save humanity.",
    isFavourite: false,
  ),
  Film(
    id: 4,
    name: "The Dark Knight",
    description: "A gritty take on Batman's fight against the Joker.",
    isFavourite: true,
  ),
  Film(
    id: 5,
    name: "The Shawshank Redemption",
    description: "The story of a man's resilience and hope in prison.",
    isFavourite: false,
  ),
  Film(
    id: 6,
    name: "Pulp Fiction",
    description: "A series of interconnected stories set in Los Angeles.",
    isFavourite: true,
  ),
  Film(
    id: 7,
    name: "Forrest Gump",
    description: "A heartwarming tale of an extraordinary life.",
    isFavourite: false,
  ),
  Film(
    id: 8,
    name: "The Lord of the Rings",
    description: "An epic journey to destroy the One Ring.",
    isFavourite: true,
  ),
  Film(
    id: 9,
    name: "Fight Club",
    description: "An exploration of identity and consumerism.",
    isFavourite: false,
  ),
  Film(
    id: 10,
    name: "The Godfather",
    description: "A powerful story of family and power.",
    isFavourite: true,
  ),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);
  
  void update(Film film, bool isFavourite) {
    state = state.map((thisFilm) => thisFilm.id == film.id ? thisFilm.copyWith(isFavourite: isFavourite) : thisFilm).toList();
  }
}

enum FavouriteStatus {
  all,
  favourite,
  notFavourite,
}

final favouriteStatusProvider = StateProvider<FavouriteStatus>((ref) => FavouriteStatus.all);
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>((ref) => FilmsNotifier());
final favouriteFilmsProvider = Provider((ref) => ref.watch(allFilmsProvider).where((film) => film.isFavourite));
final notFavouriteFilmsProvider = Provider((ref) => ref.watch(allFilmsProvider).where((film) => !film.isFavourite));

class Example6StateNotifierProvider2 extends ConsumerWidget {
  const Example6StateNotifierProvider2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example6 State Notifier2 - Films'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final filter = ref.watch(favouriteStatusProvider);
                switch (filter) {
                  case FavouriteStatus.all:
                    return FilmsList(provider: allFilmsProvider);
                  case FavouriteStatus.favourite:
                    return FilmsList(provider: favouriteFilmsProvider);
                  case FavouriteStatus.notFavourite:
                    return FilmsList(provider: notFavouriteFilmsProvider);                  
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films.elementAt(index);
        return ListTile(
          dense: true,
          title: Text(film.name),
          subtitle: Text(film.description),
          trailing: IconButton(
            onPressed: () => ref.read(allFilmsProvider.notifier).update(film, !film.isFavourite),
            icon: Icon(film.isFavourite ? Icons.favorite : Icons.favorite_outline),
          ),
        );
      },
    );
  }
}


class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          return DropdownButton<FavouriteStatus>(
            value: ref.watch(favouriteStatusProvider),
            onChanged: (FavouriteStatus? val) {
              if(val != null) {
                ref.read(favouriteStatusProvider.notifier).state = val;
              }
            },
            items: FavouriteStatus.values.map((fs) => DropdownMenuItem(
              value: fs,
              child: Text(fs.toString().split('.').last)
            )).toList(),
          );
        },
      ),
    );
  }
}
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age ]) => Person(
    name: name ?? this.name, 
    age: age ?? this.age,
  );

  String get displayName => '$name ($age years old)';
  
  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;
  
  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void add(Person person) {
    _people.add(person);
    notifyListeners();
  }
  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person person) {
    final index = _people.indexOf(person);
    final oldPerson = _people[index];
    if(oldPerson.name != person.name || oldPerson.age != person.age) {
      _people[index] = oldPerson.updated(person.name, person.age);
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider((ref) => DataModel());


class Example5FutureProvider extends ConsumerWidget {
  const Example5FutureProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example5 Notifier Provider'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(peopleProvider);
          return ListView.builder(
            shrinkWrap: true,
            itemCount: dataModel.count,
            itemBuilder: (context, index) {
              final person = dataModel.people[index];
              return ListTile(
                title: GestureDetector(
                  onTap: () => createOrUpdatePerson(context, person).then((res) {
                    if(res != null) {
                      dataModel.update(res);
                    }
                  }),
                  child: Text(person.displayName),
                ),
                trailing: IconButton(
                  onPressed: () => dataModel.remove(person), 
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createOrUpdatePerson(context).then((person) {
          if(person != null) {
            ref.read(peopleProvider).add(person);
          }
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePerson(BuildContext context, [Person? existingPerson]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;
  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';
  return showDialog<Person?>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text('${existingPerson != null ? 'Update' : 'Create'} a Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter name here...',
              ),
              onChanged: (val) => name = val,
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Enter age here...',
              ),
              onChanged: (val) => age = int.tryParse(val),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              if(name != null && age != null) {
                if(existingPerson != null) {
                  final newPerson = existingPerson.updated(name, age);
                  Navigator.of(context).pop(newPerson);
                } else {
                  final newPerson = Person(name: name!, age: age!);
                  Navigator.of(context).pop(newPerson);
                }
              } else {
                Navigator.of(context).pop();
              }
            }, 
            child: Text(existingPerson != null ? 'Update' : 'Save')
          ),
        ],
      );
    }
  );
}
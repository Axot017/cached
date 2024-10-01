import 'dart:convert';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:http/http.dart' as http;

import 'todo.dart';

part 'gen.cached.dart';

/// Sample API URL
///
/// Returns a list:
/// [
///   {
///     "userId": 1,
///     "id": 1,
///     "title": "delectus aut autem",
///     "completed": false
///   },
///   {
///     "userId": 1,
///     "id": 2,
///     "title": "quis ut nam facilis et officia qui",
///     "completed": false
///   },
///   198 more...
///  ]
const _url = 'https://jsonplaceholder.typicode.com/todos';

@withCache
abstract mixin class Gen implements _$Gen {
  factory Gen() = _Gen;

  /// For the sake of readability, we will pass only a [persistentStorage]
  /// here, but you can use any params combination
  @PersistentCached()
  Future<List<Todo>> getTodos() async {
    final uri = Uri.parse(_url);
    final response = await http.get(uri);
    final decodedBody = jsonDecode(response.body);

    return decodedBody.map<Todo>((e) => Todo.fromJson(e)).toList();
  }

  /// We will pass only a [directPersistentStorage]
  /// here becouse you can not use any params combination
  @DirectPersistentCached()
  Future<List<Todo>> getDirectTodos() async {
    final uri = Uri.parse(_url);
    final response = await http.get(uri);
    final decodedBody = jsonDecode(response.body);

    return decodedBody.map<Todo>((e) => Todo.fromJson(e)).toList();
  }

  @PersistentCached()
  Future<int> getNumber() async {
    return 42;
  }

  @DirectPersistentCached()
  Future<int> getDirectNumber() async {
    return 42;
  }

  @UpdateCache('getNumber')
  Future<int> updateNumber(@ignore int number) async {
    return number;
  }

  @UpdateCache('getDirectNumber')
  Future<int> updateDirectNumber(@ignore int number) async {
    return number;
  }

  /// To delete persisted data, you can also use [ClearAllCached],
  /// [DeletesCache] annotations.
  @ClearCached('getTodos')
  Future<void> clearTodos() async {
    print('Deleting todos from database...');
  }
}

import 'package:cached_annotation/cached_annotation.dart';

import 'gen.dart';
import 'todo_storage.dart';

/// Open [cached_example] project in ../example directory to check
/// how use [Cached] package.
///
///
/// Run this method. It'll create a database folder with two files:
/// - todos.hive
/// - todos.lock
///
/// From now on, every program run will use data stored in these files.
///
/// Examples of fetching times:
/// - 1st run: 306 ms
/// - 2nd run: 1 ms
/// - Delete ./database directory  manually or with [gen.clearTodos] method
/// - 3rd run: 298 ms
Future<void> main(List<String> arguments) async {
  /// The assignment of this variable is mandatory for [Cached] to store
  /// data in permanent memory.
  PersistentStorageHolder.storage = await TodoStorage.create();

  final gen = Gen();

  /// Uncomment to deleteTodos
  // await gen.clearTodos();

  await _fetchTodos(gen);

  await gen.getTodosWithTtl();

  final todosPeek = gen.peekMethodWithTtl();
  final maybeFirst5Todos = todosPeek?.sublist(0, 5);
  print('Peeked todos: $maybeFirst5Todos');

  await Future<void>.delayed(const Duration(seconds: 6));

  final todosPeekAfterTtl = gen.peekMethodWithTtl();
  final maybeFirst5TodosAfterTtl = todosPeekAfterTtl?.sublist(0, 5);
  print('Peeked todos after TTL: $maybeFirst5TodosAfterTtl');
}

Future<void> _fetchTodos(Gen gen) async {
  final stopwatch = Stopwatch();

  stopwatch.start();
  final todos = await gen.getTodos();
  stopwatch.stop();

  final count = todos.length;
  print('Todos count: $count items');

  final fetchTime = stopwatch.elapsedMilliseconds;
  print('Fetch time: $fetchTime ms \n');

  print('First 5 todos:');
  print(todos.sublist(0, 5));
}

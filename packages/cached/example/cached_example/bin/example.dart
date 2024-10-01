import 'dart:convert';

import '../bin/user.dart';
import 'gen.dart';

/// Open gen.dart file to check how use [Cached] package,
/// if you need more information about the package,
/// take a look at the readme!

/// Run main method to check how great [Cached] package is it!
void main(List<String> arguments) async {
  print('======= CACHED BY ITEO =======\n');

  final gen = Gen();
  final sw = Stopwatch();

  const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  final streamSubscription = gen.getDataCacheStream().listen((event) {
    print(
      'Cache updated with new value:\n${encoder.convert(jsonDecode(event.body))}',
    );
  });

  final response = await gen.getDataWithCached();

  print('Response json:');

  final String prettyprint = encoder.convert(jsonDecode(response.body));
  print('$prettyprint\n');

  sw.start();
  await gen.getDataWithCached();
  sw.stop();

  print('With cached: ${sw.elapsedMilliseconds} ms');

  sw.start();
  await gen.getDataWithoutCached();
  sw.stop();

  print('Without cached: ${sw.elapsedMilliseconds} ms');

  print('\n==============================');

  await streamSubscription.cancel();

  final updatedUser = User('123', 'John Doe', 25);

  final user = await gen.getUser('123');

  await gen.updateUser(updatedUser, 'someParam');

  final updatedUserResponse = await gen.getUser('123');

  print('\nUser before update: ${user.name}'); // John
  print('User after update: ${updatedUserResponse.name}'); // John Doe
}

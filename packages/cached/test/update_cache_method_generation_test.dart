import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  const expectedAnnotatedTests = {
    'MethodWithNoArguments',
    'AsyncMethodWithNoArguments',
    'AsyncGeneratorMethodWithNoArguments',
    'SyncGeneratorMethodWithNoArguments',
    'MethodWithPositionalArgs',
    'MethodWithOptionalArgs',
    'MethodWithNamedArgs',
    'MethodWithPositionalAndOptionalArgs',
    'MethodWithPositionalAndNamedArgs',
    'CachedWithLimit',
    'CachedWithTtl',
    'AsyncSyncWrite',
    'SyncSyncWrite',
    'IgnoreCacheParam',
    'IgnoreParam',
    'CacheKeyParam',
  };

  final reader = await initializeLibraryReaderForDirectory(
    path.join('test', 'inputs'),
    'update_cache_method_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: expectedAnnotatedTests,
  );
}

import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen_test/source_gen_test.dart';

import 'utils/test_storage.dart';

Future<void> main() async {
  PersistentStorageHolder.storage = TestStorage();

  initializeBuildLogTracking();
  const expectedAnnotatedTests = {
    'StaticPersistedRepository',
    'NonStaticPersistedRepository',
    'CachedPersistentStorageError',
    'CachedWithClearAllPersistentStorageError',
    'CachedWithClearPersistentStorageError',
    'CachedWithDeletePersistentStorageError',
    'NonStaticNestedGenericType',
    'StaticNestedGenericType',
    'DirectPersistentStoargeRepository',
    'LazyPersistentStorage',
    'AllParamsPersistentStorage',
    'UpdateCacheBasic',
  };

  final reader = await initializeLibraryReaderForDirectory(
    path.join('test', 'inputs'),
    'persistent_storage_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: expectedAnnotatedTests,
  );
}

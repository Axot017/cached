import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached_annotation/cached_annotation.dart';

const _defaultSyncWriteValue = false;

class CachedGetter extends CachedFunction {
  CachedGetter({
    required super.name,
    required super.syncWrite,
    required super.returnType,
    required super.isGenerator,
    required super.isAsync,
    required super.limit,
    required super.ttl,
    required super.checkIfShouldCacheMethod,
    required super.persistentStorage,
    required super.directPersistentStorage,
    required super.lazyPersistentStorage,
  });

  factory CachedGetter.fromElement(
    PropertyAccessorElement element,
    Config config,
  ) {
    CachedFunction.assertIsValid(element);

    var isDirect = false;
    var isPersistent = false;
    var isLazy = false;

    if (CachedFunction.hasCachedAnnotation<DirectPersistentCached>(element)) {
      isDirect = true;
    } else if (CachedFunction.hasCachedAnnotation<LazyPersistentCached>(
      element,
    )) {
      isLazy = true;
      isPersistent = true;
    } else if (CachedFunction.hasCachedAnnotation<PersistentCached>(element)) {
      isPersistent = true;
    }

    final localConfig = CachedFunctionLocalConfig.fromElement(element);
    final unsafeSyncWrite = localConfig.syncWrite ?? config.syncWrite;
    final syncWrite = unsafeSyncWrite ?? _defaultSyncWriteValue;
    final limit = isDirect ? null : localConfig.limit ?? config.limit;
    final ttl = isDirect ? null : localConfig.ttl ?? config.ttl;
    final persistentStorage = isPersistent || localConfig.persistentStorage;
    final lazyPersistentStorage = !isDirect && isLazy;
    final returnType = element.returnType.getDisplayString();

    return CachedGetter(
      name: element.name,
      syncWrite: syncWrite,
      limit: limit,
      ttl: ttl,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      persistentStorage: persistentStorage,
      directPersistentStorage: isDirect,
      returnType: returnType,
      lazyPersistentStorage: lazyPersistentStorage,
    );
  }
}

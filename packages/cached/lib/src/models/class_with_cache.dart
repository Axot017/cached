import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/constructor.dart';
import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/models/update_cache.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

const _defaultUseStaticCache = false;

class ClassWithCache {
  const ClassWithCache({
    required this.name,
    required this.useStaticCache,
    required this.methods,
    required this.constructor,
    required this.clearMethods,
    required this.streamedCacheMethods,
    required this.cachePeekMethods,
    required this.deletesCacheMethods,
    required this.getters,
    required this.updateCacheMethods,
    this.clearAllMethod,
  });

  factory ClassWithCache.fromElement(ClassElement element, Config config) {
    assertAbstract(element);
    assertOneConstFactoryConstructor(element);

    const classAnnotationChecker = TypeChecker.fromRuntime(WithCache);
    final annotation = classAnnotationChecker.firstAnnotationOf(element);

    bool? useStaticCache;

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      final useStaticCacheField = reader.read('useStaticCache');
      if (useStaticCacheField.isBool) {
        useStaticCache = useStaticCacheField.boolValue;
      }
    }

    final constructor = element.constructors
        .map((element) => Constructor.fromElement(element, config))
        .first;

    final methods = element.methods
        .where(CachedFunction.hasCachedAnnotation<Cached>)
        .map((e) => CachedMethod.fromElement(e, config));

    final methodsWithTtls = methods
        .where((method) => method.ttl != null)
        .map((method) => method.name);

    final getters = element.accessors
        .where((element) => element.isGetter)
        .where(CachedFunction.hasCachedAnnotation<Cached>)
        .map((e) => CachedGetter.fromElement(e, config));

    final gettersWithTtls = getters
        .where((getter) => getter.ttl != null)
        .map((getter) => getter.name);

    final clearMethods = element.methods
        .where((element) => ClearCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map(
          (e) => ClearCachedMethod.fromElement(
            e,
            config,
            <String>{...methodsWithTtls, ...gettersWithTtls},
          ),
        );

    assertValidateClearCachedMethods(clearMethods, methods, getters);

    final clearAllMethod = element.methods
        .where((element) => ClearAllCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map(
          (e) => ClearAllCachedMethod.fromElement(
            e,
            config,
            <String>{...methodsWithTtls, ...gettersWithTtls},
          ),
        );

    assertOneClearAllCachedAnnotation(clearAllMethod);

    final streamedCacheMethods = element.methods
        .where((element) => StreamedCacheMethod.getAnnotation(element) != null)
        .inspect(assertCorrectStreamMethodType)
        .map(
          (e) => StreamedCacheMethod.fromElement(
            e,
            [...element.methods, ...element.accessors],
            config,
          ),
        )
        .toList();

    assertOneCacheStreamPerCachedMethod(
      [...element.methods, ...element.accessors],
      streamedCacheMethods,
    );

    final cachePeekMethods = element.methods
        .where((element) => CachePeekMethod.getAnnotation(element) != null)
        .inspect(assertCorrectCachePeekMethodType)
        .map(
          (e) => CachePeekMethod.fromElement(
            e,
            [...element.methods, ...element.accessors],
            config,
          ),
        )
        .toList();

    assertOneCachePeekPerCachedMethod(
      [...element.methods, ...element.accessors],
      cachePeekMethods,
    );

    final deletesCacheMethods = element.methods
        .where((element) => DeletesCacheMethod.getAnnotation(element) != null)
        .inspect(assertCorrectDeletesCacheMethodType)
        .map(
          (e) => DeletesCacheMethod.fromElement(
            e,
            config,
            <String>{...methodsWithTtls, ...gettersWithTtls},
          ),
        )
        .toList();

    assertValidateDeletesCacheMethods(
      deletesCacheMethods,
      [...methods, ...getters],
    );

    final updateCacheMethods = [...element.methods, ...element.accessors]
        .where((element) => UpdateCacheMethod.getAnnotation(element) != null)
        .map(
          (e) => UpdateCacheMethod.fromElement(
            e,
            [...element.methods, ...element.accessors],
            config,
          ),
        )
        .toList();

    return ClassWithCache(
      name: element.name,
      useStaticCache:
          useStaticCache ?? config.useStaticCache ?? _defaultUseStaticCache,
      methods: methods,
      clearMethods: clearMethods,
      streamedCacheMethods: streamedCacheMethods,
      constructor: constructor,
      clearAllMethod: clearAllMethod.firstOrNull,
      cachePeekMethods: cachePeekMethods,
      deletesCacheMethods: deletesCacheMethods,
      getters: getters,
      updateCacheMethods: updateCacheMethods,
    );
  }

  final bool useStaticCache;
  final String name;
  final Constructor constructor;
  final Iterable<CachedMethod> methods;
  final Iterable<ClearCachedMethod> clearMethods;
  final Iterable<StreamedCacheMethod> streamedCacheMethods;
  final Iterable<CachePeekMethod> cachePeekMethods;
  final Iterable<DeletesCacheMethod> deletesCacheMethods;
  final ClearAllCachedMethod? clearAllMethod;
  final Iterable<CachedGetter> getters;
  final Iterable<UpdateCacheMethod> updateCacheMethods;
}

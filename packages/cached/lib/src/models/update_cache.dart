import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/check_if_should_cache_method.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

class UpdateCacheMethod {
  UpdateCacheMethod({
    required this.target,
    required this.params,
    required this.name,
    required this.isGetter,
    required this.syncWrite,
    required this.returnType,
    required this.targetIsGenerator,
    required this.isAsync,
    required this.targetLimit,
    required this.targetTtl,
    required this.checkIfShouldCacheMethod,
    required this.targetIsPersistentStorage,
    required this.targetIsDirectPersistentStorage,
    required this.targetIsLazyPersistentStorage,
  });

  factory UpdateCacheMethod.fromElement(
    ExecutableElement element,
    Iterable<ExecutableElement> allElements,
    Config config,
  ) {
    UpdateCacheMethod.assertIsValid(element);

    final annotation = getAnnotation(element);

    if (annotation == null) {
      throw InvalidGenerationSourceError(
        '[ERROR] Expected @UpdateCache annotation with parameters',
        element: element,
      );
    }

    final reader = ConstantReader(annotation);

    final methodName = reader.read('methodName').stringValue;

    if (methodName.isEmpty) {
      throw InvalidGenerationSourceError(
        '[ERROR] Method name cannot be empty',
        element: element,
      );
    }

    final targetElement = allElements.firstWhere(
      (e) => e.name == methodName,
      orElse: () => throw InvalidGenerationSourceError(
        '[ERROR] Method "$methodName" do not exists',
        element: element,
      ),
    );

    late final CachedFunction cachedFunction;

    if (targetElement is MethodElement) {
      cachedFunction = CachedMethod.fromElement(targetElement, config);
    } else if (targetElement is PropertyAccessorElement) {
      cachedFunction = CachedGetter.fromElement(targetElement, config);
    } else {
      throw InvalidGenerationSourceError(
        '[ERROR] Unsupported element type ${targetElement.runtimeType}',
        element: element,
      );
    }

    final returnType =
        element.returnType.getDisplayString(withNullability: false);

    final params = element.parameters.map(
      (e) => Param.fromElement(e, config),
    );

    final method = UpdateCacheMethod(
      target: cachedFunction,
      name: element.name,
      isGetter: element is PropertyAccessorElement,
      syncWrite: cachedFunction.syncWrite,
      returnType: returnType,
      isAsync: element.isAsynchronous,
      targetIsGenerator: cachedFunction.isGenerator,
      targetLimit: cachedFunction.limit,
      targetTtl: cachedFunction.ttl,
      checkIfShouldCacheMethod: cachedFunction.checkIfShouldCacheMethod,
      targetIsPersistentStorage: cachedFunction.persistentStorage ?? false,
      targetIsDirectPersistentStorage:
          cachedFunction.directPersistentStorage ?? false,
      targetIsLazyPersistentStorage:
          cachedFunction.lazyPersistentStorage ?? false,
      params: params,
    );

    return method;
  }

  final String name;
  final bool isGetter;
  final bool syncWrite;
  final String returnType;
  final bool isAsync;
  final bool targetIsGenerator;
  final int? targetLimit;
  final int? targetTtl;
  final CheckIfShouldCacheMethod? checkIfShouldCacheMethod;
  final bool targetIsPersistentStorage;
  final bool targetIsDirectPersistentStorage;
  final bool targetIsLazyPersistentStorage;
  final CachedFunction target;

  static void assertIsValid(ExecutableElement element) {
    assertMethodNotVoid(element);
    assertMethodIsNotAbstract(element);
  }

  static DartObject? getAnnotation<T extends UpdateCache>(
    ExecutableElement element,
  ) {
    final methodAnnotationChecker = TypeChecker.fromRuntime(T);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }

  static bool hasCachedAnnotation<T extends UpdateCache>(
    ExecutableElement element,
  ) {
    return getAnnotation<T>(element) != null;
  }

  final Iterable<Param> params;
}

import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _defaultOnCacheOnError = false;

class IgnoreCacheAnnotation {
  const IgnoreCacheAnnotation({
    required this.useCacheOnError,
  });

  final bool useCacheOnError;
}

class CacheKeyAnnotation {
  const CacheKeyAnnotation(
    this.cacheFunctionCall,
  );

  final String cacheFunctionCall;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheKeyAnnotation &&
          runtimeType == other.runtimeType &&
          cacheFunctionCall == other.cacheFunctionCall;

  @override
  int get hashCode => cacheFunctionCall.hashCode;
}

class Param {
  const Param({
    required this.name,
    required this.type,
    required this.isNamed,
    required this.isOptional,
    required this.ignoreCacheKey,
    this.ignoreCacheAnnotation,
    this.cacheKeyAnnotation,
    this.defaultValue,
  });

  factory Param.fromElement(ParameterElement element, Config config) {
    // Ignore cache annotation data
    const paramAnnotationChecker = TypeChecker.fromRuntime(IgnoreCache);
    const cacheKeyAnnotationChecker = TypeChecker.fromRuntime(CacheKey);

    final annotation = paramAnnotationChecker.firstAnnotationOf(element);
    final cacheKeyAnnotation =
        cacheKeyAnnotationChecker.firstAnnotationOf(element);

    IgnoreCacheAnnotation? annotationData;
    CacheKeyAnnotation? cacheKeyAnnotationData;

    if (annotation != null && cacheKeyAnnotation != null) {
      throw InvalidGenerationSourceError(
        '[ERROR] Ignore cache cannot be used with cache key annotation',
        element: element,
      );
    }

    if (annotation != null) {
      if (element.type.getDisplayString() != 'bool') {
        throw InvalidGenerationSourceError(
          '[ERROR] Ignore cache param need to be not nullable bool',
          element: element,
        );
      }
      annotationData = IgnoreCacheAnnotation(
        useCacheOnError: config.onCacheOnError ?? _defaultOnCacheOnError,
      );

      final reader = ConstantReader(annotation);
      final useCacheOnErrorField = reader.read('useCacheOnError');
      if (useCacheOnErrorField.isBool) {
        annotationData = IgnoreCacheAnnotation(
          useCacheOnError: useCacheOnErrorField.boolValue,
        );
      }
    }

    if (cacheKeyAnnotation != null) {
      final reader = ConstantReader(cacheKeyAnnotation);
      final cacheKeyFuncReader = reader.read('cacheKeyGenerator');
      final cacheKeyFunc = cacheKeyFuncReader.objectValue.toFunctionValue();
      final elementType = element.type;

      if (cacheKeyFunc != null) {
        if (cacheKeyFunc.librarySource.fullName
                .startsWith('/cached_annotation/') &&
            cacheKeyFunc.name == 'iterableCacheKeyGenerator' &&
            !(elementType.isDartCoreList ||
                elementType.isDartCoreIterable ||
                elementType.isDartCoreSet)) {
          throw InvalidGenerationSourceError(
            '[ERROR] Iterable cache key generator requires iterable parameter',
            element: element,
          );
        }

        cacheKeyAnnotationData = CacheKeyAnnotation(
          cacheKeyFunc.name,
        );
      }
    }

    const ignoreParamAnnotationChecker = TypeChecker.fromRuntime(Ignore);
    final ignoreAnnotation =
        ignoreParamAnnotationChecker.firstAnnotationOf(element);

    return Param(
      name: element.name,
      type: element.type.getDisplayString(),
      ignoreCacheAnnotation: annotationData,
      defaultValue: element.defaultValueCode,
      isNamed: element.isNamed,
      isOptional: element.isOptional,
      ignoreCacheKey: ignoreAnnotation != null,
      cacheKeyAnnotation: cacheKeyAnnotationData,
    );
  }

  final String name;
  final String type;
  final bool isNamed;
  final bool isOptional;
  final String? defaultValue;
  final IgnoreCacheAnnotation? ignoreCacheAnnotation;
  final bool ignoreCacheKey;
  final CacheKeyAnnotation? cacheKeyAnnotation;

  bool get isPositional => !isNamed;

  bool get isRequired => !isOptional;

  bool get isRequiredPositional => isRequired && isPositional;

  bool get isOptionalPositional => isOptional && isPositional;

  bool get isRequiredNamed => isRequired && isNamed;

  bool get isOptionalNamed => isOptional && isNamed;

  String get typeWithName => '$type $name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Param &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          isNamed == other.isNamed &&
          isOptional == other.isOptional &&
          defaultValue == other.defaultValue &&
          ignoreCacheAnnotation == other.ignoreCacheAnnotation &&
          ignoreCacheKey == other.ignoreCacheKey &&
          cacheKeyAnnotation == other.cacheKeyAnnotation;

  @override
  int get hashCode => Object.hash(
        name,
        type,
        isNamed,
        isOptional,
        defaultValue,
        ignoreCacheAnnotation,
        ignoreCacheKey,
        cacheKeyAnnotation,
      );
}

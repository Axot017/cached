import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

class StreamedCacheMethod {
  const StreamedCacheMethod({
    required this.name,
    required this.targetMethodName,
    required this.coreReturnType,
    required this.params,
    required this.emitLastValue,
    required this.coreReturnTypeNullable,
  });

  final String name;
  final String targetMethodName;
  final Iterable<Param> params;
  final String coreReturnType;
  final bool emitLastValue;
  final bool coreReturnTypeNullable;

  factory StreamedCacheMethod.fromElement(
    MethodElement element,
    List<MethodElement> classMethods,
    Config config,
  ) {
    final annotation = getAnnotation(element);

    var methodName = "";
    var emitLastValue = false;
    if (annotation != null) {
      final reader = ConstantReader(annotation);
      emitLastValue = reader.read('emitLastValue').boolValue;
      methodName = reader.read('methodName').stringValue;
    }

    final targetMethod =
        classMethods.where((m) => m.name == methodName).firstOrNull;

    if (targetMethod == null) {
      throw InvalidGenerationSourceError(
        '[ERROR] Method "$methodName" do not exists',
        element: element,
      );
    } else {
      const streamTypeChecker = TypeChecker.fromRuntime(Stream);
      final coreCacheStreamMethodType =
          element.returnType.typeArgumentsOf(streamTypeChecker)?.single;
      final coreCacheSteamMethodTypeStr =
          coreCacheStreamMethodType?.getDisplayString(withNullability: true);

      const futureTypeChecker = TypeChecker.fromRuntime(Future);
      final targetMethodSyncReturnType = targetMethod
              .returnType.isDartAsyncFuture
          ? targetMethod.returnType.typeArgumentsOf(futureTypeChecker)?.single
          : targetMethod.returnType;

      final targetMethodSyncTypeStr =
          targetMethodSyncReturnType?.getDisplayString(withNullability: true);

      if (coreCacheSteamMethodTypeStr != targetMethodSyncTypeStr) {
        throw InvalidGenerationSourceError(
          '[ERROR] Streamed cache method return type needs to be a Stream<$targetMethodSyncTypeStr>',
          element: element,
        );
      }

      const cachedAnnotationTypeChecker = TypeChecker.fromRuntime(Cached);

      if (!cachedAnnotationTypeChecker.hasAnnotationOf(targetMethod)) {
        throw InvalidGenerationSourceError(
          '[ERROR] Method "$methodName" do not have @cached annotation',
          element: element,
        );
      }

      const ignoreTypeChecker = TypeChecker.any([
        TypeChecker.fromRuntime(Ignore),
        TypeChecker.fromRuntime(IgnoreCache),
      ]);

      final targetMethodParameters = targetMethod.parameters
          .where((p) => !ignoreTypeChecker.hasAnnotationOf(p))
          .toList();

      if (!ListEquality<ParameterElement>(
        EqualityBy(
          (p) => _StreamedMethodParamEquality(
            name: p.name,
            type: p.type,
            optional: p.isOptional,
          ),
        ),
      ).equals(targetMethodParameters, element.parameters)) {
        throw InvalidGenerationSourceError(
          '[ERROR] Method "${targetMethod.name}" should have same parameters as "${element.name}", excluding ones marked with @ignore and @ignoreCache',
          element: element,
        );
      }

      return StreamedCacheMethod(
        name: element.name,
        coreReturnType: coreCacheSteamMethodTypeStr ?? 'dynamic',
        emitLastValue: emitLastValue,
        params: element.parameters.map((p) => Param.fromElement(p, config)),
        targetMethodName: methodName,
        coreReturnTypeNullable: coreCacheStreamMethodType?.nullabilitySuffix ==
            NullabilitySuffix.question,
      );
    }
  }

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(StreamedCache);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}

class _StreamedMethodParamEquality {
  const _StreamedMethodParamEquality({
    required this.name,
    required this.type,
    required this.optional,
  });

  final String name;
  final DartType type;
  final bool optional;

  @override
  bool operator ==(Object other) {
    if (other is _StreamedMethodParamEquality) {
      return name == other.name &&
          type.getDisplayString(withNullability: true) ==
              other.type.getDisplayString(withNullability: true) &&
          optional == optional;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        name,
        type.getDisplayString(withNullability: true),
        optional,
      );
}

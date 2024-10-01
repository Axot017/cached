import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/extensions.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';

import 'package:source_gen/source_gen.dart';

const String _clearPrefix = 'clear';

class ClearCachedMethod {
  const ClearCachedMethod({
    required this.name,
    required this.methodName,
    required this.returnType,
    required this.isAsync,
    required this.params,
    required this.isGenerator,
    required this.isAbstract,
    required this.shouldClearTtl,
  });

  factory ClearCachedMethod.fromElement(
    MethodElement element,
    Config config,
    Set<String> ttlsToClear,
  ) {
    if (PersistentStorageHolder.isStorageSet) {
      assertPersistentStorageShouldBeAsync(element);
    }

    final annotation = getAnnotation(element);
    String? methodName;

    if (annotation != null) {
      methodName = _getMethodName(annotation);
    }

    final name = element.name;
    if (methodName == null || methodName.isEmpty) {
      methodName = _validateMethodName(name, element, methodName);
    }

    final returnType = element.returnType;
    final displayType = returnType.getDisplayString();
    final parameters = element.parameters;
    final mappedParams = parameters.map((e) => Param.fromElement(e, config));
    final shouldClearTtl = ttlsToClear.contains(methodName);

    return ClearCachedMethod(
      name: name,
      methodName: methodName,
      returnType: displayType,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      isAbstract: element.isAbstract,
      params: mappedParams,
      shouldClearTtl: shouldClearTtl,
    );
  }

  final String name;
  final String methodName;
  final String returnType;
  final bool isGenerator;
  final bool isAbstract;
  final bool isAsync;
  final Iterable<Param> params;
  final bool shouldClearTtl;

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(ClearCached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }

  static String? _getMethodName(DartObject annotation) {
    final reader = ConstantReader(annotation);
    final methodNameField = reader.read('methodName');

    if (methodNameField.isString) {
      return methodNameField.stringValue;
    }

    return null;
  }

  static String _validateMethodName(
    String name,
    MethodElement element,
    String? methodName,
  ) {
    final prefixNotContained = !name.contains(_clearPrefix);

    if (prefixNotContained) {
      const message =
          "[ERROR] Name of method for which cache should be cleared is not provider. Provide it trough annotation parameter (`@ClearCached('methodName')`) or through clear function name e.g. `void ${_clearPrefix}MethodName();`";
      throw InvalidGenerationSourceError(message, element: element);
    }

    final fixedName = name.replaceAll(_clearPrefix, '');
    return fixedName.startsWithLowerCase();
  }
}

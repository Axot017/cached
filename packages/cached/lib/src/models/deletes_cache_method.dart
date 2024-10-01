import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached_annotation/cached_annotation.dart';

import 'package:source_gen/source_gen.dart';

class DeletesCacheMethod {
  const DeletesCacheMethod({
    required this.name,
    required this.methodNames,
    required this.returnType,
    required this.isAsync,
    required this.params,
    required this.isGenerator,
    required this.ttlsToClear,
  });

  factory DeletesCacheMethod.fromElement(
    MethodElement element,
    Config config,
    Set<String> ttlsToClear,
  ) {
    final annotation = getAnnotation(element);

    List<String>? methodNames;

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      final methodNameField = reader.read('methodNames');

      if (methodNameField.isList &&
          !methodNameField.listValue.any(
            (value) => value.toStringValue() == null,
          )) {
        methodNames = methodNameField.listValue
            .map(
              (e) => e.toStringValue()!,
            )
            .toList();
      }
    }

    return DeletesCacheMethod(
      name: element.name,
      methodNames: methodNames ?? [],
      returnType: element.returnType.getDisplayString(),
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      params: element.parameters.map((e) => Param.fromElement(e, config)),
      ttlsToClear: methodNames != null
          ? ttlsToClear
              .where((element) => methodNames!.contains(element))
              .toList()
          : [],
    );
  }

  final String name;
  final List<String> methodNames;
  final String returnType;
  final bool isGenerator;
  final bool isAsync;
  final Iterable<Param> params;
  final List<String> ttlsToClear;

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(DeletesCache);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}

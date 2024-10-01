import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';

import 'package:source_gen/source_gen.dart';

class ClearAllCachedMethod {
  const ClearAllCachedMethod({
    required this.name,
    required this.returnType,
    required this.isAsync,
    required this.params,
    required this.isAbstract,
    required this.ttlsToClear,
  });

  factory ClearAllCachedMethod.fromElement(
    MethodElement element,
    Config config,
    Set<String> ttlsToClear,
  ) {
    if (PersistentStorageHolder.isStorageSet) {
      assertPersistentStorageShouldBeAsync(element);
    }

    return ClearAllCachedMethod(
      name: element.name,
      returnType: element.returnType.getDisplayString(),
      isAsync: element.isAsynchronous,
      isAbstract: element.isAbstract,
      params: element.parameters.map((e) => Param.fromElement(e, config)),
      ttlsToClear: ttlsToClear,
    );
  }

  final String name;
  final String returnType;
  final bool isAbstract;
  final bool isAsync;
  final Iterable<Param> params;
  final Set<String> ttlsToClear;

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(ClearAllCached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}

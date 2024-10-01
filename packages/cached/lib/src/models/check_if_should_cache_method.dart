import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached/src/utils/utils.dart';

class CheckIfShouldCacheMethod {
  const CheckIfShouldCacheMethod({
    required this.name,
    required this.returnType,
    required this.isAsync,
  });

  factory CheckIfShouldCacheMethod.fromElements({
    required ExecutableElement annotatedMethod,
    required ExecutableElement shouldCacheFunction,
  }) {
    assertMethodReturnsBool(shouldCacheFunction);
    assertHasSingleParameterWithGivenType(
      shouldCacheFunction,
      annotatedMethod.returnType,
    );
    assertNotSyncAsyncMismatch(
      annotatedMethod,
      shouldCacheFunction,
    );

    final name = shouldCacheFunction.name;
    final returnType = shouldCacheFunction.returnType;
    final returnTypeStr = returnType.getDisplayString();
    final isAsync =
        shouldCacheFunction.isAsynchronous || isFuture(returnTypeStr);

    return CheckIfShouldCacheMethod(
      name: name,
      returnType: returnTypeStr,
      isAsync: isAsync,
    );
  }

  final String name;
  final String returnType;
  final bool isAsync;
}

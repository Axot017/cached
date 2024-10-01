import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

void assertMethodNotVoid(ExecutableElement element) {
  if (element.returnType is VoidType ||
      element.returnType.getDisplayString() == 'Future<void>') {
    throw InvalidGenerationSourceError(
      '[ERROR] Method ${element.name} returns void or Future<void> which is not allowed',
      element: element,
    );
  }
}

void assertMethodIsNotAbstract(ExecutableElement element) {
  if (element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] Cached method ${element.name} is abstract which is not allowed',
      element: element,
    );
  }
}

void assertAbstract(ClassElement element) {
  if (!element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] Class ${element.name} need to be abstract',
      element: element,
    );
  }
}

void assertOneIgnoreCacheParam(CachedMethod method) {
  final ignoraCacheParams =
      method.params.where((element) => element.ignoreCacheAnnotation != null);

  if (ignoraCacheParams.length > 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] Multiple IgnoreCache annotations in ${method.name} method',
    );
  }
}

void assertOneConstFactoryConstructor(ClassElement element) {
  final constructorElements = element.constructors;

  if (constructorElements.length != 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] To many constructors in ${element.name} class. Class can have only one constructor',
      element: element,
    );
  }

  final constructor = constructorElements.first;

  if (!constructor.isFactory) {
    throw InvalidGenerationSourceError(
      '[ERROR] Class ${element.name} need to have one factory constructor',
      element: element,
    );
  }
}

void assertOneClearAllCachedAnnotation(
  Iterable<ClearAllCachedMethod> clearAllMethod,
) {
  if (clearAllMethod.length > 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] Too many `clearAllCached` annotation, only one can be',
    );
  }
}

void assertValidateClearCachedMethods(
  Iterable<ClearCachedMethod> clearMethods,
  Iterable<CachedMethod> methods,
  Iterable<CachedGetter> getters,
) {
  for (final clearMethod in clearMethods) {
    final hasPair = [
      methods.where((element) => element.name == clearMethod.methodName),
      getters.where((element) => element.name == clearMethod.methodName),
    ].expand((element) => element).isNotEmpty;

    if (!hasPair) {
      throw InvalidGenerationSourceError(
        '[ERROR] No cache target for `${clearMethod.name}` method',
      );
    }

    if (clearMethods
            .where((element) => element.methodName == clearMethod.methodName)
            .length >
        1) {
      throw InvalidGenerationSourceError(
        '[ERROR] There are multiple targets with ClearCached annotation with the same argument',
      );
    }
  }
}

void assertCorrectClearMethodType(MethodElement element) {
  final returnType = element.returnType.getDisplayString();

  if (element.isAbstract) {
    if (element.isAsynchronous) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` must be not async method',
        element: element,
      );
    }

    if (!(isAsyncVoid(returnType) || isVoid(returnType))) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` must be a void or Future<void> method',
        element: element,
      );
    }

    if (element.parameters.isNotEmpty) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` method cant have arguments',
        element: element,
      );
    }
  } else {
    if (!isVoid(returnType) &&
        !isBool(returnType) &&
        !isAsyncVoid(returnType) &&
        !isFutureBool(returnType)) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` return type must be a void, Future<void>, bool, Future<bool>',
        element: element,
      );
    }
  }
}

void assertOneCacheStreamPerCachedMethod(
  Iterable<ExecutableElement> methods,
  Iterable<StreamedCacheMethod> streamedCacheMethods,
) {
  for (final method in methods) {
    final methodName = method.name;
    final referencingStreamedCacheMethods =
        streamedCacheMethods.where((s) => s.targetMethodName == methodName);

    if (referencingStreamedCacheMethods
            .where((s) => s.targetMethodName == methodName)
            .length >
        1) {
      throw InvalidGenerationSourceError(
        '[ERROR] `$methodName` cannot be targeted by multiple @StreamedCache methods',
        element: method,
      );
    }
  }
}

void assertOneCachePeekPerCachedMethod(
  Iterable<ExecutableElement> methods,
  Iterable<CachePeekMethod> cachePeekMethods,
) {
  for (final method in methods) {
    final methodName = method.name;
    final referencingCachePeekMethods =
        cachePeekMethods.where((s) => s.targetMethodName == methodName);

    if (referencingCachePeekMethods
            .where((s) => s.targetMethodName == methodName)
            .length >
        1) {
      throw InvalidGenerationSourceError(
        '[ERROR] `$methodName` cannot be targeted by multiple @CachePeek methods',
        element: method,
      );
    }
  }
}

void assertCorrectStreamMethodType(MethodElement element) {
  if (!element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` must be a abstract method',
      element: element,
    );
  }
}

void assertCorrectCachePeekMethodType(MethodElement element) {
  if (!element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` must be a abstract method',
      element: element,
    );
  }
}

void assertCorrectDeletesCacheMethodType(MethodElement element) {
  if (element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` cant be an abstract method',
      element: element,
    );
  }
}

void assertValidateDeletesCacheMethods(
  Iterable<DeletesCacheMethod> deletesCacheMethods,
  Iterable<CachedFunction> methods,
) {
  for (final deletesCacheMethod in deletesCacheMethods) {
    final invalidTargetMethods = deletesCacheMethod.methodNames.where(
      (method) => !methods.map((e) => e.name).contains(method),
    );

    if (invalidTargetMethods.isNotEmpty) {
      final message = invalidTargetMethods
          .map(
            (invalidTargetMethod) =>
                '[ERROR] $invalidTargetMethod is not a valid target for ${deletesCacheMethod.name}',
          )
          .join('\n');
      throw InvalidGenerationSourceError(message);
    }

    if (deletesCacheMethod.methodNames.isEmpty) {
      throw InvalidGenerationSourceError(
        '[ERROR] No target method names specified for ${deletesCacheMethod.name}',
      );
    }
  }
}

void assertMethodReturnsBool(ExecutableElement element) {
  final returnType = element.returnType.getDisplayString();
  if (!(isFutureBool(returnType) || isBool(returnType))) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` must be a bool or Future<bool> method',
      element: element,
    );
  }
}

void assertHasSingleParameterWithGivenType(
  ExecutableElement element,
  DartType expectedType,
) {
  final params = element.parameters;
  if (params.length != 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` should have exactly one parameter',
      element: element,
    );
  }

  final firstParameter = element.parameters[0];
  final syncParamType = syncReturnType(
    firstParameter.type.getDisplayString(),
  );

  final returnType = expectedType.getDisplayString();
  final syncExpectedType = syncReturnType(returnType);

  if (syncParamType != syncExpectedType) {
    throw InvalidGenerationSourceError(
      '[ERROR] Parameter: ${firstParameter.name} (of type ${firstParameter.type}) should match type $expectedType.',
      element: element,
    );
  }
}

void assertNotSyncAsyncMismatch(
  ExecutableElement first,
  ExecutableElement second,
) {
  final firstReturnType = first.returnType.getDisplayString();
  final firstReturnTypeIsFuture = isFuture(firstReturnType);

  final secondReturnType = second.returnType.getDisplayString();
  final secondReturnTypeIsFuture = isFuture(secondReturnType);

  final hasSyncAndAsyncMismatch =
      firstReturnTypeIsFuture ^ secondReturnTypeIsFuture;

  if (hasSyncAndAsyncMismatch) {
    throw InvalidGenerationSourceError(
      '[ERROR] Asynchronous and synchronous mismatch. Check return types of: ${first.name} and ${second.name}.',
      element: first,
    );
  }
}

void assertPersistentStorageShouldBeAsync(ExecutableElement element) {
  final returnType = element.returnType;
  final returnTypeIsNotFuture = !returnType.isDartAsyncFuture;
  final isNotAsync = !element.isAsynchronous;

  if (returnTypeIsNotFuture && isNotAsync) {
    final name = element.name;
    final message = '[ERROR] $name has to be async and return Future, '
        'if you want to use persistent storage.';
    throw InvalidGenerationSourceError(message);
  }
}

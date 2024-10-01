import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('[ERROR] Peek cache method return type needs to be nullable')
@withCache
abstract class CachePeekMethodReturnType {
  factory CachePeekMethodReturnType() = _CachePeekMethodReturnType;

  @cached
  int cachedMethod() {
    return 1;
  }

  @CachePeek("cachedMethod")
  String cachedPeek();
}

@ShouldThrow('[ERROR] Method "totallyWrongName" do not exists')
@withCache
abstract class MethodShouldExists {
  factory MethodShouldExists() = _MethodShouldExists;

  @cached
  int cachedMethod() {
    return 1;
  }

  @CachePeek("totallyWrongName")
  int? cachedPeek();
}

@ShouldThrow('[ERROR] Method "cachedMethod" do not have @cached annotation')
@withCache
abstract class MethodShouldHaveCachedAnnotation {
  factory MethodShouldHaveCachedAnnotation() =
      _MethodShouldHaveCachedAnnotation;

  int cachedMethod() {
    return 1;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek();
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedPeek", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParams {
  factory MethodShouldHaveSameParams() = _MethodShouldHaveSameParams;

  @cached
  Future<int> cachedMethod(String x, double y) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int z);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedPeek", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsNullable {
  factory MethodShouldHaveSameParamsNullable() =
      _MethodShouldHaveSameParamsNullable;

  @cached
  Future<int> cachedMethod(int? z) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int z);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedPeek"'
    ', excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsNoParams {
  factory MethodShouldHaveSameParamsNoParams() =
      _MethodShouldHaveSameParamsNoParams;

  @cached
  Future<int> cachedMethod() {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int z);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedPeek",'
    ' excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsWithoutIgnore {
  factory MethodShouldHaveSameParamsWithoutIgnore() =
      _MethodShouldHaveSameParamsWithoutIgnore;

  @cached
  Future<int> cachedMethod(@ignore int x) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int x);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedPeek",'
    ' excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsWithoutIgnoreCache {
  factory MethodShouldHaveSameParamsWithoutIgnoreCache() =
      _MethodShouldHaveSameParamsWithoutIgnoreCache;

  @cached
  Future<int> cachedMethod(int x, @ignoreCache bool ignoreCache) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int x, bool ignoreCache);
}

@ShouldGenerate(r'''
abstract class _$SimpleMethod {}

class _SimpleMethod with SimpleMethod implements _$SimpleMethod {
  _SimpleMethod();

  final _cachedMethodCached = <String, int>{};

  @override
  int cachedMethod() {
    final cachedValue = _cachedMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int? cachedPeek() {
    final paramsKey = "";

    return _cachedMethodCached[paramsKey];
  }
}
''')
@withCache
abstract class SimpleMethod {
  factory SimpleMethod() = _SimpleMethod;

  @cached
  int cachedMethod() {
    return 1;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek();
}

@ShouldGenerate(r'''
abstract class _$FutureMethod {}

class _FutureMethod with FutureMethod implements _$FutureMethod {
  _FutureMethod();

  final _cachedMethodCached = <String, int>{};

  @override
  Future<int> cachedMethod() async {
    final cachedValue = _cachedMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int? cachedPeek() {
    final paramsKey = "";

    return _cachedMethodCached[paramsKey];
  }
}
''')
@withCache
abstract class FutureMethod {
  factory FutureMethod() = _FutureMethod;

  @cached
  Future<int> cachedMethod() {
    return 1;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek();
}

@ShouldGenerate(r'''
abstract class _$Parameters {}

class _Parameters with Parameters implements _$Parameters {
  _Parameters();

  final _cachedMethodCached = <String, int>{};

  @override
  int cachedMethod(int x, String y) {
    final cachedValue = _cachedMethodCached["${y.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod(x, y);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached["${y.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int? cachedPeek(String y) {
    final paramsKey = "${y.hashCode}";

    return _cachedMethodCached[paramsKey];
  }
}
''')
@withCache
abstract class Parameters {
  factory Parameters() = _Parameters;

  @cached
  int cachedMethod(@ignore int x, String y) {
    return 1;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(String y);
}

@ShouldThrow(
    '[ERROR] `cachedMethod` cannot be targeted by multiple @CachePeek methods')
@withCache
abstract class DuplicateTarget {
  factory DuplicateTarget() = _DuplicateTarget;

  @cached
  Future<int> cachedMethod(int x) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int x);

  @CachePeek("cachedMethod")
  int? anotherSameCachePeek(int x);
}

@ShouldThrow('[ERROR] `cachedPeek` must be a abstract method')
@withCache
abstract class ShouldBeAbstract {
  factory ShouldBeAbstract() = _ShouldBeAbstract;

  @cached
  Future<int> cachedMethod(int x) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int x) => 1;
}

@ShouldGenerate(r'''
abstract class _$CachePeekWithCacheKey {}

class _CachePeekWithCacheKey
    with CachePeekWithCacheKey
    implements _$CachePeekWithCacheKey {
  _CachePeekWithCacheKey();

  final _cachedMethodCached = <String, int>{};

  @override
  Future<int> cachedMethod(List<int> x) async {
    final cachedValue = _cachedMethodCached["${iterableCacheKeyGenerator(x)}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod(x);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached["${iterableCacheKeyGenerator(x)}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int? cachedPeek(List<int> x) {
    final paramsKey = "${iterableCacheKeyGenerator(x)}";

    return _cachedMethodCached[paramsKey];
  }
}
''')
@withCache
abstract class CachePeekWithCacheKey {
  factory CachePeekWithCacheKey() = _CachePeekWithCacheKey;

  @cached
  Future<int> cachedMethod(@iterableCacheKey List<int> x) {
    return x[0];
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(@iterableCacheKey List<int> x);
}

@ShouldGenerate(r'''
abstract class _$StaticCache {}

class _StaticCache with StaticCache implements _$StaticCache {
  _StaticCache();

  static final _cachedMethodCached = <String, int?>{};

  @override
  Future<int?> cachedMethod(int x) async {
    final cachedValue = _cachedMethodCached["${x.hashCode}"];
    if (cachedValue == null) {
      final int? toReturn;
      try {
        final result = super.cachedMethod(x);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached["${x.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int? cachedPeek(int x) {
    final paramsKey = "${x.hashCode}";

    return _cachedMethodCached[paramsKey];
  }
}
''')
@WithCache(useStaticCache: true)
abstract class StaticCache {
  factory StaticCache() = _StaticCache;

  @cached
  Future<int?> cachedMethod(int x) {
    return y;
  }

  @CachePeek("cachedMethod")
  int? cachedPeek(int x);
}

import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldGenerate(
  r'''
abstract class _$MethodWithNoArguments {}

class _MethodWithNoArguments
    with MethodWithNoArguments
    implements _$MethodWithNoArguments {
  _MethodWithNoArguments();

  final _methodCached = <String, int>{};

  @override
  int method() {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache() {
    final int toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class MethodWithNoArguments {
  factory MethodWithNoArguments() = _MethodWithNoArguments;

  @cached
  int method() {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache() {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncMethodWithNoArguments {}

class _AsyncMethodWithNoArguments
    with AsyncMethodWithNoArguments
    implements _$AsyncMethodWithNoArguments {
  _AsyncMethodWithNoArguments();

  final _methodCached = <String, int>{};

  @override
  Future<int> method() async {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<int> updateMethodCache() async {
    final int toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = await result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class AsyncMethodWithNoArguments {
  factory AsyncMethodWithNoArguments() = _AsyncMethodWithNoArguments;

  @cached
  Future<int> method() {
    return Future.value(1);
  }

  @UpdateCache('method')
  Future<int> updateMethodCache() {
    return Future.value(2);
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncGeneratorMethodWithNoArguments {}

class _AsyncGeneratorMethodWithNoArguments
    with AsyncGeneratorMethodWithNoArguments
    implements _$AsyncGeneratorMethodWithNoArguments {
  _AsyncGeneratorMethodWithNoArguments();

  final _methodCached = <String, Stream<int>>{};

  @override
  Stream<int> method() async* {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final Stream<int> toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      yield* toReturn;
    } else {
      yield* cachedValue;
    }
  }

  @override
  Stream<int> updateMethodCache() async* {
    final Stream<int> toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    yield* toReturn;
  }
}
''',
)
@withCache
abstract class AsyncGeneratorMethodWithNoArguments {
  factory AsyncGeneratorMethodWithNoArguments() =
      _AsyncGeneratorMethodWithNoArguments;

  @cached
  Stream<int> method() async* {
    yield 1;
  }

  @UpdateCache('method')
  Stream<int> updateMethodCache() async* {
    yield 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$SyncGeneratorMethodWithNoArguments {}

class _SyncGeneratorMethodWithNoArguments
    with SyncGeneratorMethodWithNoArguments
    implements _$SyncGeneratorMethodWithNoArguments {
  _SyncGeneratorMethodWithNoArguments();

  final _methodCached = <String, Iterable<int>>{};

  @override
  Iterable<int> method() sync* {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final Iterable<int> toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      yield* toReturn;
    } else {
      yield* cachedValue;
    }
  }

  @override
  Iterable<int> updateMethodCache() sync* {
    final Iterable<int> toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    yield* toReturn;
  }
}
''',
)
@withCache
abstract class SyncGeneratorMethodWithNoArguments {
  factory SyncGeneratorMethodWithNoArguments() =
      _SyncGeneratorMethodWithNoArguments;

  @cached
  Iterable<int> method() sync* {
    yield 1;
  }

  @UpdateCache('method')
  Iterable<int> updateMethodCache() sync* {
    yield 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithPositionalArgs {}

class _MethodWithPositionalArgs
    with MethodWithPositionalArgs
    implements _$MethodWithPositionalArgs {
  _MethodWithPositionalArgs();

  final _methodCached = <String, int>{};

  @override
  int method(int a, String? b, Stream<double> c) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache(int a, String? b, Stream<double> c) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(a, b, c);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}"] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class MethodWithPositionalArgs {
  factory MethodWithPositionalArgs() = _MethodWithPositionalArgs;

  @cached
  int method(int a, String? b, Stream<double> c) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache(int a, String? b, Stream<double> c) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithOptionalArgs {}

class _MethodWithOptionalArgs
    with MethodWithOptionalArgs
    implements _$MethodWithOptionalArgs {
  _MethodWithOptionalArgs();

  final _methodCached = <String, int>{};

  @override
  int method([int a = 1, String? b, Stream<double>? c, double? d = 0.2]) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c, d);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache(
      [int a = 1, String? b, Stream<double>? c, double? d = 0.2]) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(a, b, c, d);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
        toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class MethodWithOptionalArgs {
  factory MethodWithOptionalArgs() = _MethodWithOptionalArgs;

  @cached
  int method([int a = 1, String? b, Stream<double>? c, double? d = 0.2]) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache(
      [int a = 1, String? b, Stream<double>? c, double? d = 0.2]) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithNamedArgs {}

class _MethodWithNamedArgs
    with MethodWithNamedArgs
    implements _$MethodWithNamedArgs {
  _MethodWithNamedArgs();

  final _methodCached = <String, int>{};

  @override
  int method(
      {required int a,
      required String? b,
      Stream<double>? c,
      double? d = 0.2}) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a: a, b: b, c: c, d: d);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache(
      {required int a,
      required String? b,
      Stream<double>? c,
      double? d = 0.2}) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(a: a, b: b, c: c, d: d);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
        toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class MethodWithNamedArgs {
  factory MethodWithNamedArgs() = _MethodWithNamedArgs;

  @cached
  int method({
    required int a,
    required String? b,
    Stream<double>? c,
    double? d = 0.2,
  }) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache({
    required int a,
    required String? b,
    Stream<double>? c,
    double? d = 0.2,
  }) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithPositionalAndOptionalArgs {}

class _MethodWithPositionalAndOptionalArgs
    with MethodWithPositionalAndOptionalArgs
    implements _$MethodWithPositionalAndOptionalArgs {
  _MethodWithPositionalAndOptionalArgs();

  final _methodCached = <String, int>{};

  @override
  int method(int a, String? b, [Stream<double>? c, double? d = 0.2]) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c, d);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache(int a, String? b,
      [Stream<double>? c, double? d = 0.2]) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(a, b, c, d);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
        toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class MethodWithPositionalAndOptionalArgs {
  factory MethodWithPositionalAndOptionalArgs() =
      _MethodWithPositionalAndOptionalArgs;

  @cached
  int method(
    int a,
    String? b, [
    Stream<double>? c,
    double? d = 0.2,
  ]) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache(
    int a,
    String? b, [
    Stream<double>? c,
    double? d = 0.2,
  ]) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithPositionalAndNamedArgs {}

class _MethodWithPositionalAndNamedArgs
    with MethodWithPositionalAndNamedArgs
    implements _$MethodWithPositionalAndNamedArgs {
  _MethodWithPositionalAndNamedArgs();

  final _methodCached = <String, int>{};

  @override
  int method(int a, String? b,
      {required Stream<double>? c,
      double? d = 0.2,
      required String e,
      int f = 1}) {
    final cachedValue = _methodCached[
        "${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}${e.hashCode}${f.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c: c, d: d, e: e, f: f);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[
              "${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}${e.hashCode}${f.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache(int a, String? b,
      {required Stream<double>? c,
      double? d = 0.2,
      required String e,
      int f = 1}) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(a, b, c: c, d: d, e: e, f: f);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[
            "${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}${e.hashCode}${f.hashCode}"] =
        toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class MethodWithPositionalAndNamedArgs {
  factory MethodWithPositionalAndNamedArgs() =
      _MethodWithPositionalAndNamedArgs;

  @cached
  int method(
    int a,
    String? b, {
    required Stream<double>? c,
    double? d = 0.2,
    required String e,
    int f = 1,
  }) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache(
    int a,
    String? b, {
    required Stream<double>? c,
    double? d = 0.2,
    required String e,
    int f = 1,
  }) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$CachedWithLimit {}

class _CachedWithLimit with CachedWithLimit implements _$CachedWithLimit {
  _CachedWithLimit();

  final _methodCached = <String, int>{};

  @override
  int method() {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      if (_methodCached.length > 10) {
        _methodCached.remove(_methodCached.entries.first.key);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache() {
    final int toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    if (_methodCached.length > 10) {
      _methodCached.remove(_methodCached.entries.first.key);
    }

    return toReturn;
  }
}
''',
)
@withCache
abstract class CachedWithLimit {
  factory CachedWithLimit() = _CachedWithLimit;

  @Cached(limit: 10)
  int method() {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache() {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$CachedWithTtl {}

class _CachedWithTtl with CachedWithTtl implements _$CachedWithTtl {
  _CachedWithTtl();

  final _methodCached = <String, int>{};

  final _methodTtl = <String, String>{};

  @override
  int method() {
    final now = DateTime.now();
    final cachedTtl = _methodTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _methodTtl.remove("");
      _methodCached.remove("");
    }

    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _methodTtl[""] = DateTime.now().add(duration).toIso8601String();

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache() {
    final now = DateTime.now();
    final cachedTtl = _methodTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _methodTtl.remove("");
      _methodCached.remove("");
    }

    final int toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    const duration = Duration(seconds: 30);
    _methodTtl[""] = DateTime.now().add(duration).toIso8601String();

    return toReturn;
  }
}
''',
)
@withCache
abstract class CachedWithTtl {
  factory CachedWithTtl() = _CachedWithTtl;

  @Cached(ttl: 30)
  int method() {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache() {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncSyncWrite {}

class _AsyncSyncWrite with AsyncSyncWrite implements _$AsyncSyncWrite {
  _AsyncSyncWrite();

  final _methodSync = <String, Future<int>>{};

  final _methodCached = <String, int>{};

  @override
  Future<int> method() async {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final cachedFuture = _methodSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final int toReturn;
      try {
        final result = super.method();
        _methodSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _methodSync.remove('');
      }

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<int> updateMethodCache() async {
    final int toReturn;
    try {
      final result = super.updateMethodCache();
      _methodSync[""] = result;
      toReturn = await result;
    } catch (_) {
      rethrow;
    } finally {
      _methodSync.remove('');
    }

    _methodCached[""] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class AsyncSyncWrite {
  factory AsyncSyncWrite() = _AsyncSyncWrite;

  @Cached(syncWrite: true)
  Future<int> method() async {
    return 1;
  }

  @UpdateCache('method')
  Future<int> updateMethodCache() async {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$SyncSyncWrite {}

class _SyncSyncWrite with SyncSyncWrite implements _$SyncSyncWrite {
  _SyncSyncWrite();

  final _methodSync = <String, Future<int>>{};

  final _methodCached = <String, int>{};

  @override
  int method() {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache() {
    final int toReturn;
    try {
      final result = super.updateMethodCache();

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class SyncSyncWrite {
  factory SyncSyncWrite() = _SyncSyncWrite;

  @Cached(syncWrite: true)
  int method() {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache() {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$IgnoreCacheParam {}

class _IgnoreCacheParam with IgnoreCacheParam implements _$IgnoreCacheParam {
  _IgnoreCacheParam();

  final _methodCached = <String, int>{};

  @override
  int method({bool something = false}) {
    final cachedValue = _methodCached[""];
    if (cachedValue == null || something) {
      final int toReturn;
      try {
        final result = super.method(something: something);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache({bool something = false}) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(something: something);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class IgnoreCacheParam {
  factory IgnoreCacheParam() = _IgnoreCacheParam;

  @cached
  int method({@ignoreCache bool something = false}) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache({@ignoreCache bool something = false}) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$IgnoreParam {}

class _IgnoreParam with IgnoreParam implements _$IgnoreParam {
  _IgnoreParam();

  final _methodCached = <String, int>{};

  @override
  int method({bool something = false}) {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(something: something);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache({bool something = false}) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(something: something);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class IgnoreParam {
  factory IgnoreParam() = _IgnoreParam;

  @cached
  int method({@ignore bool something = false}) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache({@ignore bool something = false}) {
    return 2;
  }
}

@ShouldGenerate(
  r'''
abstract class _$CacheKeyParam {}

class _CacheKeyParam with CacheKeyParam implements _$CacheKeyParam {
  _CacheKeyParam();

  final _methodCached = <String, int>{};

  @override
  int method({bool something = false}) {
    final cachedValue = _methodCached["${_cacheKeyGenerator(something)}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(something: something);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${_cacheKeyGenerator(something)}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  int updateMethodCache({bool something = false}) {
    final int toReturn;
    try {
      final result = super.updateMethodCache(something: something);

      toReturn = result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached["${_cacheKeyGenerator(something)}"] = toReturn;

    return toReturn;
  }
}
''',
)
@withCache
abstract class CacheKeyParam {
  factory CacheKeyParam() = _UseCacheKeyParam;

  @cached
  int method({@CacheKey(_cacheKeyGenerator) bool something = false}) {
    return 1;
  }

  @UpdateCache('method')
  int updateMethodCache(
      {@CacheKey(_cacheKeyGenerator) bool something = false}) {
    return 2;
  }
}

String _cacheKeyGenerator(dynamic value) => "testCacheKey";

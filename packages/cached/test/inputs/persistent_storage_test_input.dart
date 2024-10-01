import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldGenerate(
  r'''
abstract class _$StaticPersistedRepository {}

class _StaticPersistedRepository
    with StaticPersistedRepository
    implements _$StaticPersistedRepository {
  _StaticPersistedRepository() {
    _init();
  }

  Future<void> _init() async {
    if (_isStaticCacheLocked == true) {
      return;
    } else {
      _isStaticCacheLocked = true;
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getNumberCached');

      cachedMap.forEach((_, value) {
        if (value is! double) throw TypeError();
      });

      _getNumberCached = cachedMap;
    } catch (e) {
      _getNumberCached = <String, dynamic>{};
    }

    try {
      _getNumberTtl = await PersistentStorageHolder.read('_getNumberTtl');
    } catch (e) {
      _getNumberTtl = <String, dynamic>{};
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getBoolCached');

      cachedMap.forEach((_, value) {
        if (value is! bool) throw TypeError();
      });

      _getBoolCached = cachedMap;
    } catch (e) {
      _getBoolCached = <String, dynamic>{};
    }

    try {
      _getBoolTtl = await PersistentStorageHolder.read('_getBoolTtl');
    } catch (e) {
      _getBoolTtl = <String, dynamic>{};
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getTextCached');

      cachedMap.forEach((_, value) {
        if (value is! String) throw TypeError();
      });

      _getTextCached = cachedMap;
    } catch (e) {
      _getTextCached = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  static bool _isStaticCacheLocked = false;

  static final _getBoolSync = <String, Future<bool>>{};

  static late final Map<String, dynamic> _getNumberCached;
  static late final Map<String, dynamic> _getBoolCached;
  static late final Map<String, dynamic> _getTextCached;

  static late final _getNumberTtl;
  static late final _getBoolTtl;

  @override
  Future<double> getNumber() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumberTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumberTtl.remove("");
      _getNumberCached.remove("");
    }

    final cachedValue = _getNumberCached[""];
    if (cachedValue == null) {
      final double toReturn;
      try {
        final result = super.getNumber();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getNumberCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _getNumberTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getNumberCached', _getNumberCached);
      await PersistentStorageHolder.write('_getNumberTtl', _getNumberTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<bool> getBool() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getBoolTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getBoolTtl.remove("");
      _getBoolCached.remove("");
    }

    final cachedValue = _getBoolCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getBoolSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final bool toReturn;
      try {
        final result = super.getBool();
        _getBoolSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getBoolSync.remove('');
      }

      _getBoolCached[""] = toReturn;

      const duration = Duration(seconds: 60);
      _getBoolTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getBoolCached', _getBoolCached);
      await PersistentStorageHolder.write('_getBoolTtl', _getBoolTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> getText() async {
    await _completerFuture;

    final cachedValue = _getTextCached[""];
    if (cachedValue == null) {
      final String toReturn;
      try {
        final result = super.getText();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getTextCached[""] = toReturn;

      await PersistentStorageHolder.write('_getTextCached', _getTextCached);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> clearGetNumber() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearGetNumber();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
    }
  }

  @override
  Future<void> clearAll() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearAll();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    _getBoolCached.clear();
    _getBoolTtl.clear();

    _getTextCached.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.deleteAll();
    }
  }

  @override
  Future<void> deleteSelected() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    final result = await super.deleteSelected();

    _getNumberCached.clear();
    _getTextCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
      await PersistentStorageHolder.delete('_getTextCached');
    }

    return result;
  }
}
''',
)
@WithCache(useStaticCache: true)
abstract class StaticPersistedRepository {
  factory PersistedRepository() = _PersistedRepository;

  final _generator = Random();

  @Cached(
    syncWrite: false,
    persistentStorage: true,
    ttl: 30,
  )
  Future<double> getNumber() async {
    await _delay();
    return _generator.nextDouble() * 257;
  }

  @Cached(
    syncWrite: true,
    persistentStorage: true,
    ttl: 60,
  )
  Future<bool> getBool() async {
    await _delay();
    return _generator.nextBool();
  }

  @Cached(persistentStorage: true)
  Future<String> getText() async {
    await _delay();
    return 'Lorem ipsum.';
  }

  @clearAllCached
  Future<void> clearAll() async {}

  @ClearCached('getNumber')
  Future<void> clearGetNumber() async {}

  @DeletesCache(['getNumber', 'getText'])
  Future<void> deleteSelected() async {}

  Future<void> _delay() async {
    const duration = Duration(seconds: 1);
    await Future.delayed(duration);
  }
}

@ShouldGenerate(
  r'''
abstract class _$NonStaticPersistedRepository {}

class _NonStaticPersistedRepository
    with NonStaticPersistedRepository
    implements _$NonStaticPersistedRepository {
  _NonStaticPersistedRepository() {
    _init();
  }

  Future<void> _init() async {
    try {
      final cachedMap = await PersistentStorageHolder.read('_getNumberCached');

      cachedMap.forEach((_, value) {
        if (value is! double) throw TypeError();
      });

      _getNumberCached = cachedMap;
    } catch (e) {
      _getNumberCached = <String, dynamic>{};
    }

    try {
      _getNumberTtl = await PersistentStorageHolder.read('_getNumberTtl');
    } catch (e) {
      _getNumberTtl = <String, dynamic>{};
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getBoolCached');

      cachedMap.forEach((_, value) {
        if (value is! bool) throw TypeError();
      });

      _getBoolCached = cachedMap;
    } catch (e) {
      _getBoolCached = <String, dynamic>{};
    }

    try {
      _getBoolTtl = await PersistentStorageHolder.read('_getBoolTtl');
    } catch (e) {
      _getBoolTtl = <String, dynamic>{};
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getTextCached');

      cachedMap.forEach((_, value) {
        if (value is! String) throw TypeError();
      });

      _getTextCached = cachedMap;
    } catch (e) {
      _getTextCached = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  final _getBoolSync = <String, Future<bool>>{};

  late final Map<String, dynamic> _getNumberCached;
  late final Map<String, dynamic> _getBoolCached;
  late final Map<String, dynamic> _getTextCached;

  late final _getNumberTtl;
  late final _getBoolTtl;

  @override
  Future<double> getNumber() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumberTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumberTtl.remove("");
      _getNumberCached.remove("");
    }

    final cachedValue = _getNumberCached[""];
    if (cachedValue == null) {
      final double toReturn;
      try {
        final result = super.getNumber();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getNumberCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _getNumberTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getNumberCached', _getNumberCached);
      await PersistentStorageHolder.write('_getNumberTtl', _getNumberTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<bool> getBool() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getBoolTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getBoolTtl.remove("");
      _getBoolCached.remove("");
    }

    final cachedValue = _getBoolCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getBoolSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final bool toReturn;
      try {
        final result = super.getBool();
        _getBoolSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getBoolSync.remove('');
      }

      _getBoolCached[""] = toReturn;

      const duration = Duration(seconds: 60);
      _getBoolTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getBoolCached', _getBoolCached);
      await PersistentStorageHolder.write('_getBoolTtl', _getBoolTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> getText() async {
    await _completerFuture;

    final cachedValue = _getTextCached[""];
    if (cachedValue == null) {
      final String toReturn;
      try {
        final result = super.getText();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getTextCached[""] = toReturn;

      await PersistentStorageHolder.write('_getTextCached', _getTextCached);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> clearGetNumber() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearGetNumber();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
    }
  }

  @override
  Future<void> clearAll() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearAll();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    _getBoolCached.clear();
    _getBoolTtl.clear();

    _getTextCached.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.deleteAll();
    }
  }

  @override
  Future<void> deleteSelected() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    final result = await super.deleteSelected();

    _getNumberCached.clear();
    _getTextCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
      await PersistentStorageHolder.delete('_getTextCached');
    }

    return result;
  }
}
''',
)
@withCache
abstract class NonStaticPersistedRepository {
  factory PersistedRepository() = _PersistedRepository;

  final _generator = Random();

  @Cached(
    syncWrite: false,
    persistentStorage: true,
    ttl: 30,
  )
  Future<double> getNumber() async {
    await _delay();
    return _generator.nextDouble() * 257;
  }

  @Cached(
    syncWrite: true,
    persistentStorage: true,
    ttl: 60,
  )
  Future<bool> getBool() async {
    await _delay();
    return _generator.nextBool();
  }

  @Cached(persistentStorage: true)
  Future<String> getText() async {
    await _delay();
    return 'Lorem ipsum.';
  }

  @clearAllCached
  Future<void> clearAll() async {}

  @ClearCached('getNumber')
  Future<void> clearGetNumber() async {}

  @DeletesCache(['getNumber', 'getText'])
  Future<void> deleteSelected() async {}

  Future<void> _delay() async {
    const duration = Duration(seconds: 1);
    await Future.delayed(duration);
  }
}

@withCache
@ShouldThrow(
  '[ERROR] shouldThrowGenerationError has to be async and return Future, '
  'if you want to use persistent storage.',
  element: false,
)
abstract class CachedPersistentStorageError {
  factory CachedPersistentStorageError() = _CachedPersistentStorageError;

  @Cached(persistentStorage: true)
  int shouldThrowGenerationError() {
    return 1;
  }
}

@withCache
@ShouldThrow(
  '[ERROR] shouldThrowGenerationError has to be async and return Future, '
  'if you want to use persistent storage.',
  element: false,
)
abstract class CachedWithClearAllPersistentStorageError {
  factory CachedPersistentStorageError() = _CachedPersistentStorageError;

  @Cached(persistentStorage: true)
  Future<int> something() async {
    const delay = Duration(milliseconds: 5);
    await Future.delayed(delay);
    return 1;
  }

  @ClearAllCached()
  void shouldThrowGenerationError() {}
}

@withCache
@ShouldThrow(
  '[ERROR] shouldThrowGenerationError has to be async and return Future, '
  'if you want to use persistent storage.',
  element: false,
)
abstract class CachedWithClearPersistentStorageError {
  factory CachedPersistentStorageError() = _CachedPersistentStorageError;

  @Cached(persistentStorage: true)
  Future<int> something() async {
    const delay = Duration(milliseconds: 5);
    await Future.delayed(delay);
    return 1;
  }

  @ClearCached('something')
  void shouldThrowGenerationError() {}
}

@withCache
@ShouldThrow(
  '[ERROR] All of Cached Persistent Storage methods '
  'have to be async. Source: shouldThrowGenerationError',
  element: false,
)
abstract class CachedWithDeletePersistentStorageError {
  factory CachedPersistentStorageError() = _CachedPersistentStorageError;

  @Cached(persistentStorage: true)
  Future<int> something1() async {
    const delay = Duration(milliseconds: 3);
    await Future.delayed(delay);
    return 1;
  }

  @Cached(persistentStorage: true)
  Future<int> something2() async {
    const delay = Duration(milliseconds: 3);
    await Future.delayed(delay);
    return 2;
  }

  @DeletesCache(['something1', 'something2'])
  void shouldThrowGenerationError() {}
}

@ShouldGenerate(
  r"""
abstract class _$NonStaticNestedGenericType {}

class _NonStaticNestedGenericType
    with NonStaticNestedGenericType
    implements _$NonStaticNestedGenericType {
  _NonStaticNestedGenericType() {
    _init();
  }

  Future<void> _init() async {
    try {
      final cachedMap = await PersistentStorageHolder.read('_getNumbersCached');

      cachedMap.forEach((_, value) {
        if (value is! List<int>) throw TypeError();
      });

      _getNumbersCached = cachedMap;
    } catch (e) {
      _getNumbersCached = <String, dynamic>{};
    }

    try {
      _getNumbersTtl = await PersistentStorageHolder.read('_getNumbersTtl');
    } catch (e) {
      _getNumbersTtl = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  final _getNumbersSync = <String, Future<List<int>>>{};

  late final Map<String, dynamic> _getNumbersCached;

  late final _getNumbersTtl;

  @override
  Future<List<int>> getNumbers() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumbersTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumbersTtl.remove("");
      _getNumbersCached.remove("");
    }

    final cachedValue = _getNumbersCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getNumbersSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final List<int> toReturn;
      try {
        final result = super.getNumbers();
        _getNumbersSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getNumbersSync.remove('');
      }

      _getNumbersCached[""] = toReturn;

      if (_getNumbersCached.length > 10) {
        _getNumbersCached.remove(_getNumbersCached.entries.first.key);
      }

      const duration = Duration(seconds: 30);
      _getNumbersTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write(
          '_getNumbersCached', _getNumbersCached);
      await PersistentStorageHolder.write('_getNumbersTtl', _getNumbersTtl);

      return toReturn;
    } else {
      try {
        return cachedValue.cast<int>();
      } on NoSuchMethodError {
        throw Exception('''
             You have to provide your generic classes with a `.cast<T>()` 
             method, if you want to store them inside a persistent storage. 
             E.g.:
             
             class MyClass<T> {
               // ...       
                       
               MyClass<S> cast<S>() {
                 return MyClass<S>();
               }
             }

            ''');
      }
    }
  }
}
""",
)
@withCache
abstract class NonStaticNestedGenericType {
  factory NonStaticNestedGenericType() = _NonStaticNestedGenericType;

  @Cached(
    persistentStorage: true,
    ttl: 30,
    syncWrite: true,
    limit: 10,
  )
  Future<List<int>> getNumbers() async {
    return [1, 2, 3, 5, 8];
  }
}

@ShouldGenerate(r"""
abstract class _$StaticNestedGenericType {}

class _StaticNestedGenericType
    with StaticNestedGenericType
    implements _$StaticNestedGenericType {
  _StaticNestedGenericType() {
    _init();
  }

  Future<void> _init() async {
    if (_isStaticCacheLocked == true) {
      return;
    } else {
      _isStaticCacheLocked = true;
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getNumbersCached');

      cachedMap.forEach((_, value) {
        if (value is! List<int>) throw TypeError();
      });

      _getNumbersCached = cachedMap;
    } catch (e) {
      _getNumbersCached = <String, dynamic>{};
    }

    try {
      _getNumbersTtl = await PersistentStorageHolder.read('_getNumbersTtl');
    } catch (e) {
      _getNumbersTtl = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  static bool _isStaticCacheLocked = false;

  static final _getNumbersSync = <String, Future<List<int>>>{};

  static late final Map<String, dynamic> _getNumbersCached;

  static late final _getNumbersTtl;

  @override
  Future<List<int>> getNumbers() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumbersTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumbersTtl.remove("");
      _getNumbersCached.remove("");
    }

    final cachedValue = _getNumbersCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getNumbersSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final List<int> toReturn;
      try {
        final result = super.getNumbers();
        _getNumbersSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getNumbersSync.remove('');
      }

      _getNumbersCached[""] = toReturn;

      if (_getNumbersCached.length > 30) {
        _getNumbersCached.remove(_getNumbersCached.entries.first.key);
      }

      const duration = Duration(seconds: 20);
      _getNumbersTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write(
          '_getNumbersCached', _getNumbersCached);
      await PersistentStorageHolder.write('_getNumbersTtl', _getNumbersTtl);

      return toReturn;
    } else {
      try {
        return cachedValue.cast<int>();
      } on NoSuchMethodError {
        throw Exception('''
             You have to provide your generic classes with a `.cast<T>()` 
             method, if you want to store them inside a persistent storage. 
             E.g.:
             
             class MyClass<T> {
               // ...       
                       
               MyClass<S> cast<S>() {
                 return MyClass<S>();
               }
             }

            ''');
      }
    }
  }
}
""")
@WithCache(useStaticCache: true)
abstract class StaticNestedGenericType {
  factory NonStaticNestedGenericType() = _NonStaticNestedGenericType;

  @Cached(
    persistentStorage: true,
    ttl: 20,
    syncWrite: true,
    limit: 30,
  )
  Future<List<int>> getNumbers() async {
    return [13, 21, 34];
  }
}

@ShouldGenerate(
  r'''
abstract class _$DirectPersistentStoargeRepository {}

class _DirectPersistentStoargeRepository
    with DirectPersistentStoargeRepository
    implements _$DirectPersistentStoargeRepository {
  _DirectPersistentStoargeRepository();

  @override
  Future<double> getNumber() async {
    final cachedValue = await PersistentStorageHolder.read('_getNumberCached');
    if (cachedValue.isEmpty && cachedValue[''] == null) {
      final double toReturn;
      try {
        final result = super.getNumber();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      await PersistentStorageHolder.write('_getNumberCached', {'': toReturn});

      return toReturn;
    } else {
      return cachedValue[''];
    }
  }
}
''',
)
@WithCache()
abstract class DirectPersistentStoargeRepository
    implements _$DirectPersistentStoargeRepository {
  factory DirectPersistentStoargeRepository() =
      _DirectPersistentStoargeRepository;

  @directPersistentCached
  Future<double> getNumber() async {
    await _delay();
    return _generator.nextDouble() * 257;
  }

  Future<void> _delay() async {
    const duration = Duration(seconds: 1);
    await Future.delayed(duration);
  }
}

@ShouldGenerate(
  r'''
abstract class _$LazyPersistentStorage {}

class _LazyPersistentStorage
    with LazyPersistentStorage
    implements _$LazyPersistentStorage {
  _LazyPersistentStorage();

  Map<String, dynamic>? _methodCached = null;

  @override
  Future<int> method() async {
    if (_methodCached == null) {
      try {
        final cachedMap = await PersistentStorageHolder.read('_methodCached');

        cachedMap.forEach((_, value) {
          if (value is! int) throw TypeError();
        });

        _methodCached = cachedMap;
      } catch (e) {
        _methodCached = <String, dynamic>{};
      }
    }

    final cachedValue = _methodCached![""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached![""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class LazyPersistentStorage {
  factory LazyPersistentStorage() = _LazyPersistentStorage;

  @LazyPersistentCached()
  Future<int> method() async {
    return Future.value(1);
  }
}

@ShouldGenerate(r"""
abstract class _$AllParamsPersistentStorage {}

class _AllParamsPersistentStorage
    with AllParamsPersistentStorage
    implements _$AllParamsPersistentStorage {
  _AllParamsPersistentStorage() {
    _init();
  }

  Future<void> _init() async {
    if (_isStaticCacheLocked == true) {
      return;
    } else {
      _isStaticCacheLocked = true;
    }

    try {
      final cachedMap = await PersistentStorageHolder.read('_getNumbersCached');

      cachedMap.forEach((_, value) {
        if (value is! List<int>) throw TypeError();
      });

      _getNumbersCached = cachedMap;
    } catch (e) {
      _getNumbersCached = <String, dynamic>{};
    }

    try {
      _getNumbersTtl = await PersistentStorageHolder.read('_getNumbersTtl');
    } catch (e) {
      _getNumbersTtl = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  static bool _isStaticCacheLocked = false;

  static final _getNumbersSync = <String, Future<List<int>>>{};

  static late final Map<String, dynamic> _getNumbersCached;

  static late final _getNumbersTtl;

  @override
  Future<List<int>> getNumbers() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumbersTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumbersTtl.remove("");
      _getNumbersCached.remove("");
    }

    final cachedValue = _getNumbersCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getNumbersSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final List<int> toReturn;
      try {
        final result = super.getNumbers();
        _getNumbersSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getNumbersSync.remove('');
      }

      _getNumbersCached[""] = toReturn;

      if (_getNumbersCached.length > 30) {
        _getNumbersCached.remove(_getNumbersCached.entries.first.key);
      }

      const duration = Duration(seconds: 20);
      _getNumbersTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write(
          '_getNumbersCached', _getNumbersCached);
      await PersistentStorageHolder.write('_getNumbersTtl', _getNumbersTtl);

      return toReturn;
    } else {
      try {
        return cachedValue.cast<int>();
      } on NoSuchMethodError {
        throw Exception('''
             You have to provide your generic classes with a `.cast<T>()` 
             method, if you want to store them inside a persistent storage. 
             E.g.:
             
             class MyClass<T> {
               // ...       
                       
               MyClass<S> cast<S>() {
                 return MyClass<S>();
               }
             }

            ''');
      }
    }
  }
}
""")
@WithCache(useStaticCache: true)
abstract class AllParamsPersistentStorage {
  factory AllParamsPersistentStorage() = _AllParamsPersistentStorage;

  @PersistentCached(
    ttl: 20,
    syncWrite: true,
    limit: 30,
  )
  Future<List<int>> getNumbers() async {
    return [13, 21, 34];
  }
}

// with update cache
@ShouldGenerate(
  r'''
abstract class _$UpdateCacheBasic {}

class _UpdateCacheBasic with UpdateCacheBasic implements _$UpdateCacheBasic {
  _UpdateCacheBasic() {
    _init();
  }

  Future<void> _init() async {
    try {
      final cachedMap = await PersistentStorageHolder.read('_methodCached');

      cachedMap.forEach((_, value) {
        if (value is! int) throw TypeError();
      });

      _methodCached = cachedMap;
    } catch (e) {
      _methodCached = <String, dynamic>{};
    }

    try {
      _methodTtl = await PersistentStorageHolder.read('_methodTtl');
    } catch (e) {
      _methodTtl = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  late final Map<String, dynamic> _methodCached;

  late final _methodTtl;

  @override
  Future<int> method() async {
    await _completerFuture;

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

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      if (_methodCached.length > 10) {
        _methodCached.remove(_methodCached.entries.first.key);
      }

      const duration = Duration(seconds: 30);
      _methodTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_methodCached', _methodCached);
      await PersistentStorageHolder.write('_methodTtl', _methodTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<int> updateMethod() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _methodTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _methodTtl.remove("");
      _methodCached.remove("");
    }

    final int toReturn;
    try {
      final result = super.updateMethod();

      toReturn = await result;
    } catch (_) {
      rethrow;
    } finally {}

    _methodCached[""] = toReturn;

    if (_methodCached.length > 10) {
      _methodCached.remove(_methodCached.entries.first.key);
    }

    const duration = Duration(seconds: 30);
    _methodTtl[""] = DateTime.now().add(duration).toIso8601String();

    await PersistentStorageHolder.write('_methodCached', _methodCached);
    await PersistentStorageHolder.write('_methodTtl', _methodTtl);

    return toReturn;
  }
}
''',
)
@WithCache()
abstract class UpdateCacheBasic {
  factory UpdateCacheBasic() = _UpdateCacheBasic;

  @PersistentCached(
    ttl: 30,
    limit: 10,
  )
  Future<int> method() async {
    return 1;
  }

  @UpdateCache('method')
  Future<int> updateMethod() async {
    return 2;
  }
}

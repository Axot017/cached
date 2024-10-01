import 'package:cached/src/models/update_cache.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/common_generator.dart';
import 'package:cached/src/utils/persistent_storage_holder_texts.dart';
import 'package:cached/src/utils/utils.dart';

class UpdateCacheMethodTemplate {
  UpdateCacheMethodTemplate(
    this.function, {
    required this.useStaticCache,
    required this.isCacheStreamed,
  });

  final UpdateCacheMethod function;
  final bool useStaticCache;
  final bool isCacheStreamed;

  String generateDefinition() {
    if (function.isGetter) {
      return 'get ${function.name}';
    }

    final paramsTemplate = AllParamsTemplate(function.params);
    final params = paramsTemplate.generateParams();

    return '${function.name}($params)';
  }

  String generateUsage() {
    if (function.isGetter) {
      return function.name;
    }

    final paramsTemplate = AllParamsTemplate(function.params);
    final paramsUsage = paramsTemplate.generateParamsUsage();

    return '${function.name}($paramsUsage)';
  }

  String get paramsKey => getParamKey(function.params);

  String get _cacheMapName => getCacheMapName(function.target.name);

  String get _ttlMapName => getTtlMapName(function.target.name);

  String get _syncMapName => '_${function.target.name}Sync';

  bool get _returnsFuture => isFuture(function.returnType);

  String get _syncReturnType => syncReturnType(function.returnType);

  String get _returnKeyword => function.targetIsGenerator ? 'yield*' : 'return';

  String get _toReturnVariable => 'toReturn';

  bool get _lazyPersistentStorage => function.targetIsLazyPersistentStorage;

  bool get _shouldUsePersistentStorage => function.targetIsPersistentStorage;
  bool get _shouldUseDirectPersistentStorage =>
      function.targetIsDirectPersistentStorage;

  bool get _hasTtl => function.targetTtl != null;

  String generate() {
    final generatorModifier = function.targetIsGenerator ? '*' : '';

    final isGeneratorOrAsync = function.targetIsGenerator && !function.isAsync;
    final syncGeneratorModifier = isGeneratorOrAsync ? 'sync' : '';

    final returnsFutureOrIsAsync = _returnsFuture || function.isAsync;
    final checkIfShouldCacheMethod = function.checkIfShouldCacheMethod;
    final shouldCacheAsync = checkIfShouldCacheMethod?.isAsync;
    final cacheAsync = shouldCacheAsync == true;
    final useAsyncKeyword = returnsFutureOrIsAsync || cacheAsync;
    final asyncModifier = useAsyncKeyword ? 'async' : '';

    final generatedDefinition = generateDefinition();
    final usage = generateUsage();

    return '''
       @override
       ${function.returnType} $generatedDefinition $syncGeneratorModifier$asyncModifier$generatorModifier {
          ${_generateLazyPersistentStorageCache()}
          ${_generateStorageAwait()}
                 
          ${_generateRemoveTtlLogic()}
          
          final $_syncReturnType $_toReturnVariable;
          try {
              final result = super.$usage;
              ${function.syncWrite && _returnsFuture ? '$_syncMapName["$paramsKey"] = result;' : ""}
              $_toReturnVariable = ${_returnsFuture ? 'await' : ''} result;
          } catch(_) {
              rethrow;
          } finally {
              ${function.syncWrite && _returnsFuture ? "$_syncMapName.remove('$paramsKey');" : ""}
          }

          ${_generateUpdateCacheMap()}

          ${_generateStreamCall()}

          ${_generateLimitLogic()}
          ${_generateAddTtlLogic()}
    
          ${_generateCacheWrite()}
          ${_generateTtlWrite()}
    
          $_returnKeyword $_toReturnVariable;
        }
   ''';
  }

  String generateSyncMap() {
    if (!function.syncWrite) {
      return '';
    }

    final staticModifier = _getStaticModifier();
    return '$staticModifier final $_syncMapName = <String, Future<$_syncReturnType>>{};';
  }

  String generateCacheMap() {
    final staticModifier = _getStaticModifier();

    if (_shouldUseDirectPersistentStorage) {
      return '';
    }

    if (_shouldUsePersistentStorage && !_lazyPersistentStorage) {
      return '$staticModifier late final Map<String, dynamic> $_cacheMapName;';
    }

    if (_lazyPersistentStorage) {
      return '$staticModifier Map<String, dynamic>? $_cacheMapName = null;';
    }

    return '$staticModifier final $_cacheMapName = <String, $_syncReturnType>{};';
  }

  String generateTtlMap() {
    final staticModifier = _getStaticModifier();

    if (!_hasTtl) {
      return '';
    }

    if (_shouldUsePersistentStorage) {
      return '$staticModifier late final $_ttlMapName;';
    }

    return '$staticModifier final $_ttlMapName = <String, String>{};';
  }

  String generateAsyncPersistentStorageInit() {
    final buffer = StringBuffer();
    if (_shouldUsePersistentStorage) {
      final cacheInit = _getCacheInit();
      buffer.writeln(cacheInit);
      buffer.writeln('\n');
    }

    if (_shouldUsePersistentStorage && _hasTtl) {
      final ttlInit = _getTtlInit();
      buffer.writeln(ttlInit);
      buffer.writeln('\n');
    }

    return buffer.toString();
  }

  String _getCacheLazyPersistentStorage() {
    return '''
      if($_cacheMapName == null) {
        ${_getCacheInit()}
        }
    ''';
  }

  String _getCacheInit() {
    final init = '''
      final cachedMap = $readCodeText('$_cacheMapName');
      
      cachedMap.forEach((_, value) {
        if (value is! $_syncReturnType) throw TypeError();
      });
      
      
      $_cacheMapName = cachedMap;
    ''';

    return _wrapWithTryCatchAndAssignEmptyMap(
      init,
      _cacheMapName,
    );
  }

  String _getTtlInit() {
    final init = "$_ttlMapName = $readCodeText('$_ttlMapName');";
    return _wrapWithTryCatchAndAssignEmptyMap(
      init,
      _ttlMapName,
    );
  }

  String _wrapWithTryCatchAndAssignEmptyMap(
    String dangerousInit,
    String mapName,
  ) {
    return '''
       try {
          $dangerousInit
       } catch (e) {
          $mapName = <String, dynamic>{};
       }
    ''';
  }

  String _getStaticModifier() {
    return useStaticCache ? 'static' : '';
  }

  String _generateLazyPersistentStorageCache() {
    if (_shouldUsePersistentStorage && _lazyPersistentStorage) {
      return _getCacheLazyPersistentStorage();
    }

    return '';
  }

  String _generateStorageAwait() {
    if (_shouldUsePersistentStorage &&
        !function.targetIsLazyPersistentStorage) {
      return CommonGenerator.awaitCompleterFutureText;
    }

    return '';
  }

  String _generateRemoveTtlLogic() {
    if (!_hasTtl) return '';

    return '''
       final now = DateTime.now();
       final cachedTtl = $_ttlMapName["$paramsKey"];
       final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

       if (currentTtl != null && currentTtl.isBefore(now)) {
          $_ttlMapName.remove("$paramsKey");
          $_cacheMapName.remove("$paramsKey");
       }
    ''';
  }

  String _generateAddTtlLogic() {
    if (!_hasTtl) return '';

    return '''
       const duration = Duration(seconds: ${function.targetTtl});
       $_ttlMapName["$paramsKey"] = DateTime.now().add(duration).toIso8601String();
    ''';
  }

  String _generateCacheWrite() {
    if (_shouldUsePersistentStorage && !_lazyPersistentStorage) {
      return "$writeCodeText('$_cacheMapName', $_cacheMapName);";
    } else if (_shouldUseDirectPersistentStorage) {
      return "$writeCodeText('$_cacheMapName', {'': toReturn});";
    } else if (_shouldUseDirectPersistentStorage && _lazyPersistentStorage) {
      return "$writeCodeText('$_cacheMapName', $_cacheMapName!);";
    }

    return '';
  }

  String _generateTtlWrite() {
    if (_hasTtl && _shouldUsePersistentStorage) {
      return "$writeCodeText('$_ttlMapName', $_ttlMapName);";
    }

    return '';
  }

  String _generateLimitLogic() {
    if (function.targetLimit == null) return '';

    return '''
       if ($_cacheMapName.length > ${function.targetLimit}) {
          $_cacheMapName.remove($_cacheMapName.entries.first.key);
       }
    ''';
  }

  String _generateUpdateCacheMap() {
    if (_shouldUseDirectPersistentStorage) {
      return '';
    }

    if (_lazyPersistentStorage) {
      return '$_cacheMapName!["$paramsKey"] = $_toReturnVariable;';
    }
    return '$_cacheMapName["$paramsKey"] = $_toReturnVariable;';
  }

  String _generateStreamCall() {
    if (!isCacheStreamed) {
      return '';
    }

    return '''
       ${getCacheStreamControllerName(function.target.name)}.sink.add(MapEntry(StreamEventIdentifier(
           ${useStaticCache ? '' : 'instance: this,'}
            paramsKey: "$paramsKey",
           ),
           $_toReturnVariable,
           ),
      );
    ''';
  }
}

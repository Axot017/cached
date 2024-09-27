import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class CachePeekMethodTemplate {
  CachePeekMethodTemplate(
    this.method, {
    required this.className,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final CachePeekMethod method;
  final String className;
  final AllParamsTemplate paramsTemplate;

  String get _ttlMapName => getTtlMapName(method.targetMethodName);

  String generateMethod() {
    final params = paramsTemplate.generateParams();
    final paramKey = getParamKey(method.params);
    final cacheMapName = getCacheMapName(method.targetMethodName);

    final returnNullIfExpired = method.targetHasTtl
        ? '''
        final now = DateTime.now();
        final cachedTtl = $_ttlMapName[paramsKey];
        final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

        if (currentTtl != null && currentTtl.isBefore(now)) {
          return null;
        }
        '''
        : '';

    return '''
      @override
      ${method.returnType}? ${method.name}($params)  {
        final paramsKey = "$paramKey";

        $returnNullIfExpired

        return $cacheMapName[paramsKey];
    }
    ''';
  }
}

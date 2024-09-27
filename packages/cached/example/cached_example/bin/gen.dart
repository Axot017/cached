import 'dart:convert';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:http/http.dart';

/// Do not forget add part keyword for file,
/// because then class not be generated.
part 'gen.cached.dart';

/// You can change url to your own and run main method to check
/// how many time you save with [Cached] package.
///
/// IMPORTANT!
/// response body must be a json string
const _url = 'https://jsonplaceholder.typicode.com/todos/94';

/// Annotating a class with @WithCache will flag it as a needing
/// to be processed by Cached code generator.
/// It can take one additional boolean parameter useStaticCache.
/// If this parameter is set to true, generator will generate
/// cached class with static cache. It means each instance of this class
/// will have access to the same cache. Default value is set to false
@WithCache(useStaticCache: true)
abstract mixin class Gen implements _$Gen {
  /// Factory constructor
  factory Gen() = _Gen;

  /// Method decorator that flag it as needing to be processed
  /// by Cached code generator.
  ///
  /// There are 4 possible additional parameters:
  ///
  /// * ttl - time to live. In seconds. Set how long cache will be alive.
  ///         Default value is set to null, means infinitive ttl.
  ///
  /// * syncWrite - Affects only async methods (those one that returns Future)
  ///               If set to true first method call will be cached, and if
  ///               following (the same) call will occur, all of them will get
  ///               result from the first call. Default value is set to false;
  ///
  /// * limit - limit how many results for different method call arguments
  ///           combination will be cached. Default value null, means no limit.
  ///
  /// * where - function triggered before caching the value.
  ///           If returns `true`: value will be cached,
  ///           if returns `false`: cache will not happen.
  ///           Useful to signal that a certain result must not be cached
  ///           (e.g. condition whether or not to cache known once acquiring data)
  ///
  /// * persistentStorage - defines optional usage of external persistent
  ///                       storage (e.g. shared preferences)
  ///
  ///                       If set to `true` in order to work, you have to set
  ///                       `PersistentStorageHolder.storage` in your main.dart
  ///                       file
  ///
  ///                       Important:
  ///                       If you want to utilize persistent storage, all
  ///                       methods which use Cached library's annotations has
  ///                       to be async
  ///
  /// Additional annotation @IgnoreCache
  ///
  /// That annotation must be above a field in a method and must be bool,
  /// if true the cache will be ignored. Also you can use parameter `useCacheOnError`
  /// in the annotation and if set true then return the last cached value
  /// when an error occurs.
  ///
  /// Additional annotation @ignore
  ///
  /// Arguments with @ignore annotations will be ignored while generating cache key.
  @Cached(
    syncWrite: true,
    ttl: 30,
    limit: 10,
    where: _shouldCache,
  )
  Future<Response> getDataWithCached({
    @IgnoreCache(useCacheOnError: true) bool ignoreCache = false,
  }) {
    return get(Uri.parse(_url));
  }

  /// @Cached annotation also works with getters
  @Cached(
    syncWrite: true,
    ttl: 30,
    limit: 10,
    where: _shouldCache,
  )
  Future<Response> get getDataWithCachedGetter async => get(Uri.parse(_url));

  /// Method for measure example, you can go to example.dart file
  /// and run main method, so you can check how great [Checked] package is it.
  Future<Response> getDataWithoutCached() {
    return get(Uri.parse(_url));
  }

  /// Method for getting stream of cache updates
  @StreamedCache(methodName: 'getDataWithCached')
  Stream<Response> getDataCacheStream();

  /// Method for getting data of cache method
  @CachePeek('getDataWithCached')
  Response? peekDataCache();

  /// Method annotated with this annotation can be used to clear result
  /// of method annotated with Cached annotation.
  ///
  /// IMPORTANT!
  /// the ClearCached argument or method name has to correspond
  /// to cached method name.
  @ClearCached('getDataWithCached')
  void clearDataCache();

  /// Method annotated with @DeletesCache annotation will clear
  /// cached results if it returns with value; however if this method
  /// would throw exception, cached data would not be cleared
  ///
  /// IMPORTANT!
  /// Method names passed in annotation must correspond to
  /// valid cached method names
  @DeletesCache(['getDataWithCached'])
  Future<int> deletesCache() async {
    return 1;
  }

  /// Method with this annotation will clear cached values for all methods.
  @clearAllCached
  void clearAllCache();

  @Cached(ttl: 20)
  Future<int?> cachedMethodWithTtl(int x) async {
    return 3;
  }

  @CachePeek('cachedMethodWithTtl')
  int? peekCachedMethodWithTtl(int x);
}

Future<bool> _shouldCache(Response response) async {
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  print('Up to you: check conditionally and decide if should cache: $json');
  print('For now: always cache');
  return true;
}

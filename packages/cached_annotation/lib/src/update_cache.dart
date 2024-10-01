import 'package:meta/meta_meta.dart';

/// {@template cached.updatecache}
/// ### Cached
///
/// Annotation for `Cached` package.
///
/// Method decorator that flag it as needing to be processed
/// by `Cached` code generator.
///
/// ### Example
///
/// Use @cached annotation to cache method result and generate cache store
///
/// ```dart
/// @cached
/// Future<SomeResponseType> getUserData(String id) {
///   return dataSource.getData(id);
/// }
/// ```
///
/// The cached method will generate a cache store where parameters
/// will be used as a key to store the result of the method.
///
/// Updating the cache can be done by using the `@UpdateCache` annotation.
/// When updating the cache, the cache key must be the same as the original
/// data to reflect the changes in the cache store.
///
/// For example, if you're storing users by id and you want to update the user
/// while passing updates User object to the 'updateUser' method, the user object
/// must be annotated with custom cache key generator to ensure that the cache
///
/// ```dart
///  @UpdateCache('getUser')
///  Future<User> updateUser(
///    @CacheKey(getUserKeyHash) User updatedUser,
///    @ignore String otherParamToBeIgnoredWhileGeneratingCacheKey,
///  ) async {
///    return updatedUser;
///  }
/// ```
///
/// With the 'getUserKeyHash' method, generating meaningful cache key for user:
/// ```dart
/// String getUserKeyHash(dynamic updatedUser) {
///  return updatedUser.id.hashCode;
/// }
/// ```
///
/// The relevant cache store will be updated with the new user object.
/// {@endtemplate}
@Target({TargetKind.method, TargetKind.getter})
class UpdateCache {
  /// {@macro cached.updatecache}
  const UpdateCache(this.methodName);

  /// The name of the method that should be updated in the cache store.
  final String methodName;
}

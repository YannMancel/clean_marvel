import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';

/// **Responsibility**: Implement [ComicCharacterRepository] using
/// [NetworkInfo], [ComicCharacterRemoteApi] and [ComicCharacterLocalDatabase].
class ComicCharacterRepositoryImpl implements ComicCharacterRepository {
  const ComicCharacterRepositoryImpl({
    required NetworkInfo networkInfo,
    required ComicCharacterRemoteApi remoteApi,
    required ComicCharacterLocalDatabase localDatabase,
  })  : _networkInfo = networkInfo,
        _remoteApi = remoteApi,
        _localDatabase = localDatabase;

  final NetworkInfo _networkInfo;
  final ComicCharacterRemoteApi _remoteApi;
  final ComicCharacterLocalDatabase _localDatabase;

  @override
  Future<Result<List<ComicCharacterEntity>>> getComicCharacters() async {
    try {
      final hasNetwork = await _networkInfo.isConnected;
      if (hasNetwork) {
        final remoteModels = await _remoteApi.getModels();
        final isCacheSuccess =
            await _localDatabase.addModelsAfterResetByTransaction(remoteModels);
        if (!isCacheSuccess) throw const Failure.cache();
      }

      final localModels = await _localDatabase.getModels();
      return Result<List<ComicCharacterEntity>>.data(
        localModels.convertToEntities,
      );
    } on Failure catch (e) {
      return Result<List<ComicCharacterEntity>>.error(exception: e);
    } catch (_) {
      return const Result<List<ComicCharacterEntity>>.error(
        exception: Failure.unknown(),
      );
    }
  }
}

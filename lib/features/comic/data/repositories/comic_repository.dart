import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';

class ComicRepository implements ComicRepositoryInterface {
  const ComicRepository({
    required NetworkDataInterface networkData,
    required ComicRemoteDataSourceInterface remoteDataSource,
    required ComicLocalDataSourceInterface localDataSource,
  })  : _networkData = networkData,
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final NetworkDataInterface _networkData;
  final ComicRemoteDataSourceInterface _remoteDataSource;
  final ComicLocalDataSourceInterface _localDataSource;

  @override
  Future<Result<List<ComicCharacterEntity>>> getComicCharacters() async {
    try {
      final hasNetwork = await _networkData.isConnected;

      late List<ComicCharacterModel> models;
      if (hasNetwork) {
        models = await _remoteDataSource.getComicCharacters();
        await _localDataSource.cacheComicCharacters(models);
      } else {
        models = await _localDataSource.getComicCharacters();
      }

      final entities = models.map((model) => model.convertToEntity).toList();

      return Result<List<ComicCharacterEntity>>.data(entities);
    } on Failure catch (e) {
      return Result<List<ComicCharacterEntity>>.error(exception: e);
    } catch (_) {
      return const Result<List<ComicCharacterEntity>>.error(
        exception: Failure.unknown(),
      );
    }
  }
}

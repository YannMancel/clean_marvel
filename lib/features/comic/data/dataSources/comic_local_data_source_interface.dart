import 'package:clean_marvel/features/comic/data/_data.dart';

abstract interface class ComicLocalDataSourceInterface {
  Future<List<ComicCharacterModel>> getComicCharacters();
  Future<void> cacheComicCharacters(List<ComicCharacterModel> models);
}

import 'package:clean_marvel/features/comic/data/_data.dart';

abstract interface class ComicRemoteDataSourceInterface {
  Future<List<ComicCharacterModel>> getComicCharacters();
}

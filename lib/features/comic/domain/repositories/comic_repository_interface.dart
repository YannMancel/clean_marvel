import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';

abstract interface class ComicRepositoryInterface {
  Future<Result<List<ComicCharacterEntity>>> getComicCharacters();
}

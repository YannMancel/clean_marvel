import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/marvel/domain/entities/_entities.dart';

abstract interface class MarvelRepositoryInterface {
  Future<Result<List<MarvelCharacterEntity>>> getMarvelCharacters();
}

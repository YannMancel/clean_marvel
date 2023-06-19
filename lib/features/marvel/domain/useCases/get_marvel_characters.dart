import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/marvel/domain/_domain.dart';

class GetMarvelCharacters {
  const GetMarvelCharacters(MarvelRepositoryInterface repository)
      : _repository = repository;

  final MarvelRepositoryInterface _repository;

  Future<Result<List<MarvelCharacterEntity>>> execute() async {
    return _repository.getMarvelCharacters();
  }
}

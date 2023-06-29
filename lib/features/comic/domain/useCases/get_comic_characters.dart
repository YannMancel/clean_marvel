import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';

class GetComicCharacters {
  const GetComicCharacters(ComicRepositoryInterface repository)
      : _repository = repository;

  final ComicRepositoryInterface _repository;

  Future<Result<List<ComicCharacterEntity>>> execute() async {
    return _repository.getComicCharacters();
  }
}

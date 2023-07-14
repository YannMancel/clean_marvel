import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';

class GetComicCharacters
    implements UseCaseInterface<List<ComicCharacterEntity>> {
  const GetComicCharacters({
    required ComicRepositoryInterface repository,
  }) : _repository = repository;

  final ComicRepositoryInterface _repository;

  @override
  Future<Result<List<ComicCharacterEntity>>> call() async {
    return _repository.getComicCharacters();
  }
}

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';

abstract interface class UseCase<T> {
  Future<Result<T>> call();
}

class GetComicCharacters implements UseCase<List<ComicCharacterEntity>> {
  const GetComicCharacters({
    required ComicCharacterRepository repository,
  }) : _repository = repository;

  final ComicCharacterRepository _repository;

  @override
  Future<Result<List<ComicCharacterEntity>>> call() async {
    return _repository.getComicCharacters();
  }
}

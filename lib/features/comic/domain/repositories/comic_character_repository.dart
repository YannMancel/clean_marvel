import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';

/// **Responsibility**: Group together all the possible actions on
/// [ComicCharacterEntity].
abstract interface class ComicCharacterRepository {
  Future<Result<List<ComicCharacterEntity>>> getComicCharacters();
}

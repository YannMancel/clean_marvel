import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:isar/isar.dart';

/// The data source allows to manage in local way.
///
/// ```dart
/// final dir = await getApplicationDocumentsDirectory();
///
/// final isar = Isar.open(
///   <CollectionSchema<dynamic>>[
///     ComicCharacterModelSchema,
///   ],
///   directory: dir.path,
/// );
///
/// final localDataSource = ComicLocalDataSource(isar: isar);
/// ```
class ComicLocalDataSource implements ComicLocalDataSourceInterface {
  const ComicLocalDataSource({required Isar isar}) : _isar = isar;

  final Isar _isar;

  @override
  Future<void> cacheComicCharacters(List<ComicCharacterModel> models) async {
    await _isar.writeTxn(() async {
      await _isar.comicCharacters.clear();

      for (final model in models) {
        await _isar.comicCharacters.put(model);
      }
    });
  }

  @override
  Future<List<ComicCharacterModel>> getComicCharacters() async {
    return _isar.comicCharacters.where().findAll();
  }
}

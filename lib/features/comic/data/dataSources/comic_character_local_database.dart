import 'package:clean_marvel/features/_features.dart';
import 'package:flutter/foundation.dart';

/// **Responsibility**: Group together all the useful actions of the local
/// database for [ComicCharacterModel].
abstract interface class ComicCharacterLocalDatabase {
  Future<bool> addModelsAfterResetByTransaction(
    List<ComicCharacterModel> models,
  );
  Future<List<ComicCharacterModel>> getModels();
}

class ComicCharacterLocalDatabaseImpl implements ComicCharacterLocalDatabase {
  const ComicCharacterLocalDatabaseImpl({
    required LocalDatabase localDatabase,
  }) : _localDatabase = localDatabase;

  final LocalDatabase _localDatabase;

  @visibleForTesting
  AsyncValueGetter<List<int>> clearAndAddModelsCallback(
    List<ComicCharacterModel> models,
  ) {
    return () async {
      await _localDatabase.deleteModels<ComicCharacterModel>();
      return _localDatabase.addModels<ComicCharacterModel>(models);
    };
  }

  @override
  Future<bool> addModelsAfterResetByTransaction(
    List<ComicCharacterModel> models,
  ) async {
    final addedModelIds = await _localDatabase.actionsByTransaction<List<int>>(
      asyncCallback: clearAndAddModelsCallback(models),
    );
    return models.length == addedModelIds?.length;
  }

  @override
  Future<List<ComicCharacterModel>> getModels() async {
    return _localDatabase.getModels<ComicCharacterModel>();
  }
}

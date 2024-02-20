import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late Isar isar;
  late LocalDatabase database;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      <CollectionSchema<dynamic>>[ComicCharacterModelSchema],
      // It will create the following isar files at the project root.
      //  - default.isar
      //  - default.isar.lock
      //  - libisar.dylib
      directory: '',
    );
  });

  tearDownAll(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('LocalDatabase', () {
    setUp(() async {
      database = LocalDatabaseByIsar(isar: isar);
    });

    tearDown(() async {
      await isar.writeTxn(
        () async {
          await isar.collection<ComicCharacterModel>().clear();
        },
      );
    });

    test(
      'should be success when database adds model.',
      () async {
        final addedId = await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.addModel<ComicCharacterModel>(kModel);
          },
        );
        expect(addedId, isNotNull);
        expect(addedId, kModel.localId);
        final models = await database.getModels<ComicCharacterModel>();
        expect(models, kModels);
      },
      tags: 'isar',
    );

    test(
      'should be success when database adds models.',
      () async {
        final addedIds = await database.actionsByTransaction<List<int>>(
          asyncCallback: () async {
            return database.addModels<ComicCharacterModel>(kModels);
          },
        );
        expect(addedIds, isNotNull);
        expect(addedIds, kModels.localIds);
        final models = await database.getModels<ComicCharacterModel>();
        expect(models, kModels);
      },
      tags: 'isar',
    );

    test(
      'should be success when database get model by id.',
      () async {
        await database.actionsByTransaction<List<int>>(
          asyncCallback: () async {
            return database.addModels<ComicCharacterModel>(kModels);
          },
        );
        final model = await database.getModelById<ComicCharacterModel>(
          kModel.localId,
        );
        expect(model, isNotNull);
        expect(model, kModel);
      },
      tags: 'isar',
    );

    test(
      'should be success when database get stream of model by id.',
      () async {
        final stream = database
            .getModelStreamById<ComicCharacterModel>(kModel.localId)
            .asBroadcastStream(
          onListen: (subscription) async {
            await database.actionsByTransaction<List<int>>(
              asyncCallback: () async {
                return database.addModels<ComicCharacterModel>(kModels);
              },
            );
          },
        );
        expectLater(
          stream,
          emitsInOrder(
            <ComicCharacterModel>[kModel],
          ),
        );
      },
      tags: 'isar',
    );

    test(
      'should be a success when database is open the first time '
      '(empty list).',
      () async {
        final models = await database.getModels<ComicCharacterModel>();
        expect(models, const <ComicCharacterModel>[]);
      },
      tags: 'isar',
    );

    test(
      'should be success when database get stream of models.',
      () async {
        final stream =
            database.getModelsStream<ComicCharacterModel>().asBroadcastStream(
          onListen: (subscription) async {
            await database.actionsByTransaction<List<int>>(
              asyncCallback: () async {
                return database.addModels<ComicCharacterModel>(kModels);
              },
            );
          },
        );
        expectLater(
          stream,
          emitsInOrder(
            const <ComicCharacterModel>[],
          ),
        );
      },
      tags: 'isar',
    );

    test(
      'should be success when database updates model.',
      () async {
        await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.addModel<ComicCharacterModel>(kModel);
          },
        );
        final model = await database.getModelById<ComicCharacterModel>(
          kModel.localId,
        );
        expect(model, isNotNull);
        final updatedId = await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.updateModel<ComicCharacterModel>(
              model!.copyWith(imageUrl: 'other image url'),
            );
          },
        );
        expect(updatedId, isNotNull);
        expect(updatedId, kModel.localId);
        final updatedModel = await database.getModelById<ComicCharacterModel>(
          kModel.localId,
        );
        expect(updatedModel, isNotNull);
        expect(
          updatedModel,
          kModel.copyWith(imageUrl: 'other image url'),
        );
      },
      tags: 'isar',
    );

    test(
      'should be success when database updates models.',
      () async {
        await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.addModel<ComicCharacterModel>(kModel);
          },
        );
        final models = await database.getModels<ComicCharacterModel>();
        expect(models, kModels);
        final updatedIds = await database.actionsByTransaction<List<int>>(
          asyncCallback: () async {
            return database.updateModels<ComicCharacterModel>(
              <ComicCharacterModel>[
                kModel.copyWith(imageUrl: 'other image url'),
              ],
            );
          },
        );
        expect(updatedIds, isNotNull);
        expect(updatedIds, kModels.localIds);
        final updatedModels = await database.getModels<ComicCharacterModel>();
        expect(
          updatedModels,
          <ComicCharacterModel>[
            kModel.copyWith(imageUrl: 'other image url'),
          ],
        );
      },
      tags: 'isar',
    );

    test(
      'should be success when database deletes model by id.',
      () async {
        await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.addModel<ComicCharacterModel>(kModel);
          },
        );
        final model = await database.getModelById<ComicCharacterModel>(
          kModel.localId,
        );
        expect(model, isNotNull);
        expect(model, kModel);
        final isDeleted = await database.actionsByTransaction<bool>(
          asyncCallback: () async {
            return database.deleteModelById<ComicCharacterModel>(
              kModel.localId,
            );
          },
        );
        expect(isDeleted, isTrue);
        final models = await database.getModels<ComicCharacterModel>();
        expect(models.isEmpty, isTrue);
      },
      tags: 'isar',
    );

    test(
      'should be success when database deletes models by id.',
      () async {
        await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.addModel<ComicCharacterModel>(kModel);
          },
        );
        final models = await database.getModels<ComicCharacterModel>();
        expect(models, kModels);
        final deletedModelCount = await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.deleteModelsByIds<ComicCharacterModel>(
              <int>[kModel.localId],
            );
          },
        );
        expect(deletedModelCount, 1);
        final modelsAfterDeleteAction =
            await database.getModels<ComicCharacterModel>();
        expect(modelsAfterDeleteAction.isEmpty, isTrue);
      },
      tags: 'isar',
    );

    test(
      'should be success when database deletes models.',
      () async {
        await database.actionsByTransaction<int>(
          asyncCallback: () async {
            return database.addModel<ComicCharacterModel>(kModel);
          },
        );
        final models = await database.getModels<ComicCharacterModel>();
        expect(models, kModels);
        await database.actionsByTransaction<void>(
          asyncCallback: () async {
            return database.deleteModels<ComicCharacterModel>();
          },
        );
        final modelsAfterDeleteAction =
            await database.getModels<ComicCharacterModel>();
        expect(modelsAfterDeleteAction.isEmpty, isTrue);
      },
      tags: 'isar',
    );
  });
}

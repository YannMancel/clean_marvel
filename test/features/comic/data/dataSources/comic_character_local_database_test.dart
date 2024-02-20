import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<LocalDatabase>(),
  ],
)
import 'comic_character_local_database_test.mocks.dart';

void main() {
  late MockLocalDatabase database;
  late ComicCharacterLocalDatabase overLayer;

  group('ComicCharacterLocalDatabase', () {
    setUp(() async {
      database = MockLocalDatabase();
      overLayer = ComicCharacterLocalDatabaseImpl(
        localDatabase: database,
      );
    });

    test(
      'should be a success when over layer get models from database.',
      () async {
        when(database.getModels<ComicCharacterModel>())
            .thenAnswer((_) async => kModels);
        final models = await overLayer.getModels();
        expect(models, kModels);
        verify(database.getModels<ComicCharacterModel>()).called(1);
        verifyNoMoreInteractions(database);
      },
    );

    group('when over layer performs transaction on database', () {
      test(
        'should be success.',
        () async {
          when(
            database.actionsByTransaction<List<int>>(
              asyncCallback: anyNamed('asyncCallback'),
            ),
          ).thenAnswer((_) async => kModels.localIds);
          final isSuccess = await overLayer.addModelsAfterResetByTransaction(
            kModels,
          );
          expect(isSuccess, isTrue);
          verify(database.actionsByTransaction<List<int>>(
            asyncCallback: anyNamed('asyncCallback'),
          )).called(1);
          verifyNoMoreInteractions(database);
        },
      );

      test(
        'should be fail (add not models).',
        () async {
          when(
            database.actionsByTransaction<List<int>>(
              asyncCallback: anyNamed('asyncCallback'),
            ),
          ).thenAnswer((_) async => const <int>[]);
          final isSuccess = await overLayer.addModelsAfterResetByTransaction(
            kModels,
          );
          expect(isSuccess, isFalse);
          verify(database.actionsByTransaction<List<int>>(
            asyncCallback: anyNamed('asyncCallback'),
          )).called(1);
          verifyNoMoreInteractions(database);
        },
      );
    });

    group('when over layer clears and adds models in database', () {
      test(
        'should be success.',
        () async {
          when(
            database.deleteModels<ComicCharacterModel>(),
          ).thenAnswer((_) async {});
          when(
            database.addModels<ComicCharacterModel>(any),
          ).thenAnswer((_) async => kModels.localIds);
          final ids = await (overLayer as ComicCharacterLocalDatabaseImpl)
              .clearAndAddModelsCallback(kModels)();
          expect(ids, kModels.localIds);
          verify(database.deleteModels<ComicCharacterModel>()).called(1);
          verify(database.addModels<ComicCharacterModel>(any)).called(1);
          verifyNoMoreInteractions(database);
        },
      );

      test(
        'should be fail (clear error).',
        () async {
          when(
            database.deleteModels<ComicCharacterModel>(),
          ).thenThrow(kCacheFailure);
          final call = (overLayer as ComicCharacterLocalDatabaseImpl)
              .clearAndAddModelsCallback(kModels);
          expect(
            () async => call(),
            throwsA(const TypeMatcher<CacheFailure>()),
          );
          verify(database.deleteModels<ComicCharacterModel>()).called(1);
          verifyNoMoreInteractions(database);
        },
      );

      test(
        'should be fail (add error).',
        () async {
          when(
            database.deleteModels<ComicCharacterModel>(),
          ).thenAnswer((_) async {});
          when(
            database.addModels<ComicCharacterModel>(any),
          ).thenThrow(kCacheFailure);
          final call = (overLayer as ComicCharacterLocalDatabaseImpl)
              .clearAndAddModelsCallback(kModels);
          await expectLater(
            () async => call(),
            throwsA(const TypeMatcher<CacheFailure>()),
          );
          verify(database.deleteModels<ComicCharacterModel>()).called(1);
          verify(database.addModels<ComicCharacterModel>(any)).called(1);
          verifyNoMoreInteractions(database);
        },
      );
    });
  });
}

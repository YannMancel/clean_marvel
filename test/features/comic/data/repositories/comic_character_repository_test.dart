import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<NetworkInfo>(),
    MockSpec<ComicCharacterRemoteApi>(),
    MockSpec<ComicCharacterLocalDatabase>(),
  ],
)
import 'comic_character_repository_test.mocks.dart';

void main() {
  late NetworkInfo networkInfo;
  late ComicCharacterRemoteApi remoteApi;
  late ComicCharacterLocalDatabase localDatabase;
  late ComicCharacterRepository repository;

  group('ComicRepository', () {
    setUp(() {
      networkInfo = MockNetworkInfo();
      remoteApi = MockComicCharacterRemoteApi();
      localDatabase = MockComicCharacterLocalDatabase();
      repository = ComicCharacterRepositoryImpl(
        networkInfo: networkInfo,
        remoteApi: remoteApi,
        localDatabase: localDatabase,
      );
    });

    group('when network is connected', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should be a success when network call and cache are validated.',
        () async {
          when(remoteApi.getModels()).thenAnswer((_) async => kModels);
          when(localDatabase.addModelsAfterResetByTransaction(kModels))
              .thenAnswer((_) async => true);
          when(localDatabase.getModels()).thenAnswer((_) async => kModels);
          final result = await repository.getComicCharacters();
          expect(result, resultOfData);
          verify(networkInfo.isConnected).called(1);
          verify(remoteApi.getModels()).called(1);
          verify(localDatabase.addModelsAfterResetByTransaction(kModels))
              .called(1);
          verify(localDatabase.getModels()).called(1);
          verifyNoMoreInteractions(networkInfo);
          verifyNoMoreInteractions(remoteApi);
          verifyNoMoreInteractions(localDatabase);
        },
      );

      test(
        'should be a fail when network call is fail '
        '(Server failure).',
        () async {
          when(remoteApi.getModels()).thenThrow(const Failure.server());
          final result = await repository.getComicCharacters();
          expect(result, resultOfError(exception: kServerFailure));
          verify(networkInfo.isConnected).called(1);
          verify(remoteApi.getModels()).called(1);
          verifyNoMoreInteractions(networkInfo);
          verifyNoMoreInteractions(remoteApi);
          verifyZeroInteractions(localDatabase);
        },
      );

      test(
        'should be a fail when network call is validated and cache is fail '
        '(Cache failure).',
        () async {
          when(remoteApi.getModels()).thenAnswer((_) async => kModels);
          when(localDatabase.addModelsAfterResetByTransaction(kModels))
              .thenThrow(const Failure.cache());
          final result = await repository.getComicCharacters();
          expect(result, resultOfError(exception: kCacheFailure));
          verify(networkInfo.isConnected).called(1);
          verify(remoteApi.getModels()).called(1);
          verify(localDatabase.addModelsAfterResetByTransaction(kModels))
              .called(1);
          verifyNever(localDatabase.getModels());
          verifyNoMoreInteractions(networkInfo);
          verifyNoMoreInteractions(localDatabase);
          verifyNoMoreInteractions(remoteApi);
        },
      );
    });

    group('when network is disconnected', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should be a success when cache is a success.',
        () async {
          when(localDatabase.getModels()).thenAnswer((_) async => kModels);
          final result = await repository.getComicCharacters();
          expect(result, resultOfData);
          verify(networkInfo.isConnected).called(1);
          verify(localDatabase.getModels()).called(1);
          verifyNever(localDatabase.addModelsAfterResetByTransaction(kModels));
          verifyNoMoreInteractions(networkInfo);
          verifyNoMoreInteractions(localDatabase);
          verifyZeroInteractions(remoteApi);
        },
      );

      test(
        'should be a fail when cache is fail '
        '(Cache failure).',
        () async {
          when(localDatabase.getModels()).thenThrow(const Failure.cache());
          final result = await repository.getComicCharacters();
          expect(result, resultOfError(exception: kCacheFailure));
          verify(networkInfo.isConnected).called(1);
          verify(localDatabase.getModels()).called(1);
          verifyNoMoreInteractions(networkInfo);
          verifyNoMoreInteractions(localDatabase);
          verifyZeroInteractions(remoteApi);
        },
      );
    });

    group('when network is disconnected (kUnknown exception)', () {
      setUp(() {
        when(networkInfo.isConnected).thenThrow(basicException);
      });

      test('should be a fail when network is checked.', () async {
        final result = await repository.getComicCharacters();
        expect(result, resultOfError(exception: kUnknownFailure));
        verify(networkInfo.isConnected).called(1);
        verifyNoMoreInteractions(networkInfo);
        verifyZeroInteractions(localDatabase);
        verifyZeroInteractions(remoteApi);
      });
    });
  });
}

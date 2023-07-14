import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<NetworkDataInterface>(),
    MockSpec<ComicRemoteDataSourceInterface>(),
    MockSpec<ComicLocalDataSourceInterface>(),
  ],
)
import 'comic_repository_test.mocks.dart';

void main() {
  late NetworkDataInterface networkData;
  late ComicRemoteDataSourceInterface remoteDataSource;
  late ComicLocalDataSourceInterface localDataSource;
  late ComicRepositoryInterface repository;

  group('ComicRepository', () {
    setUp(() {
      networkData = MockNetworkDataInterface();
      remoteDataSource = MockComicRemoteDataSourceInterface();
      localDataSource = MockComicLocalDataSourceInterface();
      repository = ComicRepository(
        networkData: networkData,
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );
    });

    test(
      'should be a success when network is connected, '
      'api call is a success and cache is a success.',
      () async {
        when(networkData.isConnected).thenAnswer((_) async => true);
        when(remoteDataSource.getComicCharacters())
            .thenAnswer((_) async => kModels);
        when(localDataSource.cacheComicCharacters(kModels))
            .thenAnswer((_) async {});

        final result = await repository.getComicCharacters();

        expect(result, resultOfData);
        verify(networkData.isConnected).called(1);
        verify(remoteDataSource.getComicCharacters()).called(1);
        verify(localDataSource.cacheComicCharacters(kModels)).called(1);
        verifyNever(localDataSource.getComicCharacters());
        verifyNoMoreInteractions(networkData);
        verifyNoMoreInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'should be a success when network is disconnected, '
      'api call is a success and cache is a success.',
      () async {
        when(networkData.isConnected).thenAnswer((_) async => false);
        when(localDataSource.getComicCharacters())
            .thenAnswer((_) async => kModels);

        final result = await repository.getComicCharacters();

        expect(result, resultOfData);
        verify(networkData.isConnected).called(1);
        verify(localDataSource.getComicCharacters()).called(1);
        verifyNever(localDataSource.cacheComicCharacters(kModels));
        verifyNever(remoteDataSource.getComicCharacters());
        verifyNoMoreInteractions(networkData);
        verifyNoMoreInteractions(localDataSource);
        verifyZeroInteractions(remoteDataSource);
      },
    );

    test('should be a fail when network is checked.', () async {
      when(networkData.isConnected).thenThrow(basicException);

      final result = await repository.getComicCharacters();

      expect(result, resultOfError(exception: kUnknownFailure));
      verify(networkData.isConnected).called(1);
      verifyNever(localDataSource.getComicCharacters());
      verifyNever(remoteDataSource.getComicCharacters());
      verifyNoMoreInteractions(networkData);
      verifyZeroInteractions(localDataSource);
      verifyZeroInteractions(remoteDataSource);
    });

    test(
      'should be a fail when network is connected and api call is fail.',
      () async {
        when(networkData.isConnected).thenAnswer((_) async => true);
        when(remoteDataSource.getComicCharacters())
            .thenThrow(const Failure.server());

        final result = await repository.getComicCharacters();

        expect(result, resultOfError(exception: kServerFailure));
        verify(networkData.isConnected).called(1);
        verify(remoteDataSource.getComicCharacters()).called(1);
        verifyNever(localDataSource.getComicCharacters());
        verifyNoMoreInteractions(networkData);
        verifyNoMoreInteractions(remoteDataSource);
        verifyZeroInteractions(localDataSource);
      },
    );

    test(
      'should be a fail when network is connected, api call is success '
      'and cache is fail.',
      () async {
        when(networkData.isConnected).thenAnswer((_) async => true);
        when(remoteDataSource.getComicCharacters())
            .thenAnswer((_) async => kModels);
        when(localDataSource.cacheComicCharacters(kModels))
            .thenThrow(const Failure.cache());

        final result = await repository.getComicCharacters();

        expect(result, resultOfError(exception: kCacheFailure));
        verify(networkData.isConnected).called(1);
        verify(remoteDataSource.getComicCharacters()).called(1);
        verify(localDataSource.cacheComicCharacters(kModels)).called(1);
        verifyNever(localDataSource.getComicCharacters());
        verifyNoMoreInteractions(networkData);
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be a fail when network is disconnected and cache is fail.',
      () async {
        when(networkData.isConnected).thenAnswer((_) async => false);
        when(localDataSource.getComicCharacters())
            .thenThrow(const Failure.cache());

        final result = await repository.getComicCharacters();

        expect(result, resultOfError(exception: kCacheFailure));
        verify(networkData.isConnected).called(1);
        verify(localDataSource.getComicCharacters()).called(1);
        verifyNever(remoteDataSource.getComicCharacters());
        verifyNoMoreInteractions(networkData);
        verifyNoMoreInteractions(localDataSource);
        verifyZeroInteractions(remoteDataSource);
      },
    );
  });
}

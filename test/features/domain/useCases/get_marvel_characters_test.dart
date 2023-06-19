import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/marvel/domain/_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(<MockSpec>[MockSpec<MarvelRepositoryInterface>()])
import 'get_marvel_characters_test.mocks.dart';

void main() {
  late MarvelRepositoryInterface repository;
  late GetMarvelCharacters useCase;

  group('GetMarvelCharacters', () {
    setUp(() {
      repository = MockMarvelRepositoryInterface();
      useCase = GetMarvelCharacters(repository);
    });

    test('should return a success result', () async {
      const kSuccessResult = Result<List<MarvelCharacterEntity>>.data(
        <MarvelCharacterEntity>[
          MarvelCharacterEntity(
            name: 'FAKE_NAME',
            imageUrl: 'FAKE_IMAGE',
          ),
        ],
      );

      when(repository.getMarvelCharacters())
          .thenAnswer((_) async => kSuccessResult);

      final result = await useCase.execute();

      expect(result, kSuccessResult);
      verify(repository.getMarvelCharacters()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a fail result', () async {
      final failResult = Result<List<MarvelCharacterEntity>>.error(
        exception: Exception('FAKE_EXCEPTION'),
      );

      when(repository.getMarvelCharacters())
          .thenAnswer((_) async => failResult);

      final result = await useCase.execute();

      expect(result, failResult);
      verify(repository.getMarvelCharacters()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}

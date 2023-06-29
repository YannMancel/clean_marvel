import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<ComicRepositoryInterface>(),
  ],
)
import 'get_comic_characters_test.mocks.dart';

void main() {
  late ComicRepositoryInterface repository;
  late GetComicCharacters useCase;

  group('GetComicCharacters', () {
    setUp(() {
      repository = MockComicRepositoryInterface();
      useCase = GetComicCharacters(repository);
    });

    test('should be a success when use case is called.', () async {
      when(repository.getComicCharacters())
          .thenAnswer((_) async => resultOfData);

      final result = await useCase.execute();

      expect(result, resultOfData);
      verify(repository.getComicCharacters()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should be a fail when use case is called.', () async {
      when(repository.getComicCharacters())
          .thenAnswer((_) async => resultOfErrorWithBasicException);

      final result = await useCase.execute();

      expect(result, resultOfErrorWithBasicException);
      verify(repository.getComicCharacters()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}

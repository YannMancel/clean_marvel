import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<ComicCharacterRepository>(),
  ],
)
import 'get_comic_characters_test.mocks.dart';

void main() {
  late ComicCharacterRepository repository;
  late UseCase<List<ComicCharacterEntity>> useCase;

  group('GetComicCharacters', () {
    setUp(() {
      repository = MockComicCharacterRepository();
      useCase = GetComicCharacters(repository: repository);
    });

    test(
      'should be a success when use case is called.',
      () async {
        when(repository.getComicCharacters())
            .thenAnswer((_) async => resultOfData);
        final result = await useCase();
        expect(result, resultOfData);
        verify(repository.getComicCharacters()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should be a fail when use case is called '
      '(Basic exception).',
      () async {
        when(repository.getComicCharacters())
            .thenAnswer((_) async => resultOfError(exception: basicException));
        final result = await useCase();
        expect(result, resultOfError(exception: basicException));
        verify(repository.getComicCharacters()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}

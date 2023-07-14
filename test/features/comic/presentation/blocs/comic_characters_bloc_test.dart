import 'package:bloc_test/bloc_test.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:clean_marvel/features/comic/presentation/_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<UseCaseInterface<List<ComicCharacterEntity>>>(
      as: #MockGetComicCharacters,
    ),
  ],
)
import 'comic_characters_bloc_test.mocks.dart';

void main() {
  late UseCaseInterface<List<ComicCharacterEntity>> useCase;
  late ComicCharactersBloc bloc;
  late ComicCharactersEvent event;

  group('ComicCharactersBloc', () {
    setUp(() {
      useCase = MockGetComicCharacters();
      bloc = ComicCharactersBloc(useCase: useCase);
    });

    test(
      'should have a loading state when it is at the creation bloc.',
      () async {
        expect(bloc.state, const ComicCharactersState.loading());
        verifyZeroInteractions(useCase);
      },
    );

    group('when started event is emitted', () {
      setUp(() {
        event = const ComicCharactersEvent.started();
      });

      blocTest<ComicCharactersBloc, ComicCharactersState>(
        'should emit 2 states, a loading state then data state.',
        setUp: () async {
          when(useCase()).thenAnswer((_) async => resultOfData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <ComicCharactersState>[
          const ComicCharactersState.loading(),
          ComicCharactersState.data(entities: entities),
        ],
        verify: (_) {
          verify(useCase()).called(1);
          verifyNoMoreInteractions(useCase);
        },
      );

      blocTest<ComicCharactersBloc, ComicCharactersState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(useCase()).thenAnswer(
              (_) async => resultOfError(exception: kUnknownFailure));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <ComicCharactersState>[
          ComicCharactersState.loading(),
          ComicCharactersState.error(exception: kUnknownFailure),
        ],
        verify: (_) {
          verify(useCase()).called(1);
          verifyNoMoreInteractions(useCase);
        },
      );
    });

    group('when refreshed event is emitted', () {
      setUp(() {
        event = const ComicCharactersEvent.refreshed();
      });

      blocTest<ComicCharactersBloc, ComicCharactersState>(
        'should emit 2 states, a loading state then data state.',
        setUp: () async {
          when(useCase()).thenAnswer((_) async => resultOfData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <ComicCharactersState>[
          const ComicCharactersState.loading(),
          ComicCharactersState.data(entities: entities),
        ],
        verify: (_) {
          verify(useCase()).called(1);
          verifyNoMoreInteractions(useCase);
        },
      );

      blocTest<ComicCharactersBloc, ComicCharactersState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(useCase()).thenAnswer(
              (_) async => resultOfError(exception: kUnknownFailure));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <ComicCharactersState>[
          ComicCharactersState.loading(),
          ComicCharactersState.error(exception: kUnknownFailure),
        ],
        verify: (_) {
          verify(useCase()).called(1);
          verifyNoMoreInteractions(useCase);
        },
      );
    });
  });
}

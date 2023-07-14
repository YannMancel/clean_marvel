import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:clean_marvel/features/comic/presentation/_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
import '../blocs/comic_characters_bloc_test.mocks.dart';

void main() {
  late UseCaseInterface<List<ComicCharacterEntity>> useCase;
  late Widget widget;

  group('ComicCharactersPage', () {
    setUp(() {
      useCase = MockGetComicCharacters();
      widget = const ComicCharactersPage(title: kAppTitle);
    });

    testWidgets(
      'should have a correct title in its properties.',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ComicCharactersBloc>(
              create: (_) => ComicCharactersBloc(useCase: useCase),
              child: widget,
            ),
          ),
        );

        final properties = widget.toDiagnosticsNode().getProperties();
        final propertyOrNull = properties
            .where(
              (node) => node.name == ComicCharactersPage.titlePropertyName,
            )
            .firstOrNull;

        expect(propertyOrNull, isNotNull);
        expect(propertyOrNull!.value, isA<String>());
        expect(propertyOrNull.value, kAppTitle);
      },
    );

    testWidgets('should be in loading state.', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ComicCharactersBloc>(
            create: (_) => ComicCharactersBloc(
              initialState: const ComicCharactersState.loading(),
              useCase: useCase,
            ),
            child: widget,
          ),
        ),
      );

      expect(find.byKey(ComicCharactersPage.loadingKey), findsOneWidget);
      expect(find.byType(ComicCharactersWidget), findsNothing);
      expect(find.text('error'), findsNothing);
    });

    testWidgets('should be in data state.', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ComicCharactersBloc>(
            create: (_) => ComicCharactersBloc(
              initialState: ComicCharactersState.data(entities: entities),
              useCase: useCase,
            ),
            child: widget,
          ),
        ),
      );

      expect(find.byKey(ComicCharactersPage.loadingKey), findsNothing);
      expect(find.byType(ComicCharactersWidget), findsOneWidget);
      expect(find.text('error'), findsNothing);
    });

    void generateTestWidgetWithErrorState({
      required String errorLabel,
      required Exception exception,
    }) {
      return testWidgets('should be in error state ($errorLabel).',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ComicCharactersBloc>(
              create: (_) => ComicCharactersBloc(
                initialState: ComicCharactersState.error(exception: exception),
                useCase: useCase,
              ),
              child: widget,
            ),
          ),
        );

        expect(find.byKey(ComicCharactersPage.loadingKey), findsNothing);
        expect(find.byType(ComicCharactersWidget), findsNothing);
        expect(find.text(errorLabel), findsOneWidget);
      });
    }

    generateTestWidgetWithErrorState(
      errorLabel: 'No catch error',
      exception: basicException,
    );

    generateTestWidgetWithErrorState(
      errorLabel: 'Server error',
      exception: kServerFailure,
    );

    generateTestWidgetWithErrorState(
      errorLabel: 'Cache error',
      exception: kCacheFailure,
    );

    generateTestWidgetWithErrorState(
      errorLabel: 'Unknown error',
      exception: kUnknownFailure,
    );

    testWidgets('should have a refresh event.', (tester) async {
      when(useCase()).thenAnswer((_) async => resultOfData);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ComicCharactersBloc>(
            create: (_) => ComicCharactersBloc(useCase: useCase),
            child: widget,
          ),
        ),
      );
      await tester.pump();

      await tester.fling(
        find.byKey(ComicCharactersPage.loadingKey),
        const Offset(0.0, 300.0),
        1000.0,
      );
      await tester.pump();

      // finish the scroll animation
      await tester.pump(const Duration(seconds: 1));
      // finish the indicator settle animation
      await tester.pump(const Duration(seconds: 1));
      // finish the indicator hide animation
      await tester.pump(const Duration(seconds: 1));

      await untilCalled(useCase());
      verify(useCase()).called(1);
    });
  });
}

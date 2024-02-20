import 'package:clean_marvel/features/_features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late Widget widget;
  late Widget material;

  group('ComicCharactersWidget', () {
    group('when there is no entity', () {
      setUp(() {
        widget = ComicCharactersWidget(
          List<ComicCharacterEntity>.empty(),
        );
        material = MaterialApp(home: widget);
      });

      testWidgets(
        'should have no entity in its properties.',
        (tester) async {
          await tester.pumpWidget(material);
          final properties = widget.toDiagnosticsNode().getProperties();
          final propertyOrNull = properties.where(
            (node) {
              return node.name == ComicCharactersWidget.entitiesPropertyName;
            },
          ).firstOrNull;
          expect(propertyOrNull, isNotNull);
          expect(propertyOrNull!.value, isA<List<ComicCharacterEntity>>());
          expect(propertyOrNull.value, List<ComicCharacterEntity>.empty());
        },
      );

      testWidgets('should display a correct message.', (tester) async {
        await tester.pumpWidget(material);
        expect(find.text('No data'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });
    });

    group('when there is entities', () {
      setUp(() {
        widget = ComicCharactersWidget(entities);
        material = MaterialApp(home: widget);
      });

      testWidgets(
        'should have no entity in its properties.',
        (tester) async {
          await tester.pumpWidget(material);
          final properties = widget.toDiagnosticsNode().getProperties();
          final propertyOrNull = properties.where(
            (node) {
              return node.name == ComicCharactersWidget.entitiesPropertyName;
            },
          ).firstOrNull;
          expect(propertyOrNull, isNotNull);
          expect(propertyOrNull!.value, isA<List<ComicCharacterEntity>>());
          expect(propertyOrNull.value, entities);
        },
      );

      testWidgets('should display a list of card.', (tester) async {
        await tester.pumpWidget(material);
        expect(find.text('No data'), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ComicCharacterCard), findsWidgets);
      });
    });
  });
}

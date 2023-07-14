import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:clean_marvel/features/comic/presentation/_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late Widget widget;
  late Widget material;

  setUpAll(() {
    widget = ComicCharacterCard(entity);
    material = MaterialApp(home: widget);
  });

  group('ComicCharacterCard', () {
    testWidgets(
      'should have correct entity in its properties.',
      (tester) async {
        await tester.pumpWidget(material);

        final properties = widget.toDiagnosticsNode().getProperties();
        final propertyOrNull = properties
            .where((node) => node.name == ComicCharacterCard.entityPropertyName)
            .firstOrNull;

        expect(propertyOrNull, isNotNull);
        expect(propertyOrNull!.value, isA<ComicCharacterEntity>());
        expect(propertyOrNull.value, entity);
      },
    );

    testWidgets('should display the entity name.', (tester) async {
      await tester.pumpWidget(material);

      expect(find.text(entity.name), findsOneWidget);
    });
  });
}

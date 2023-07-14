import 'package:clean_marvel/core/_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WidgetBuilder builder;
  late Widget widget;
  late Widget material;

  setUpAll(() {
    builder = (_) => const Text('FAKE_DATA');
    widget = ScrollViewWithOnlyOneWidget(builder: builder);
    material = MaterialApp(home: widget);
  });

  group('ScrollViewWithOnlyOneWidget', () {
    testWidgets(
      'should have correct builder in its properties.',
      (tester) async {
        await tester.pumpWidget(material);

        final properties = widget.toDiagnosticsNode().getProperties();
        final propertyOrNull = properties
            .where(
              (node) =>
                  node.name == ScrollViewWithOnlyOneWidget.builderPropertyName,
            )
            .firstOrNull;

        expect(propertyOrNull, isNotNull);
        expect(propertyOrNull!.value, isA<WidgetBuilder>());
        expect(propertyOrNull.value, builder);
      },
    );

    testWidgets('should be composed by different types.', (tester) async {
      await tester.pumpWidget(material);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });
  });
}

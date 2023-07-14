import 'package:clean_marvel/core/_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String imageUrl;
  late Widget widget;
  late Widget material;

  setUpAll(() {
    imageUrl = './test/fixtures/flutter.png';
    widget = ImageUrl(imageUrl);
    material = MaterialApp(home: widget);
  });

  group('ImageUrl', () {
    testWidgets(
      'should have correct imageUrl in its properties.',
      (tester) async {
        await tester.pumpWidget(material);

        final properties = widget.toDiagnosticsNode().getProperties();
        final propertyOrNull = properties
            .where((node) => node.name == ImageUrl.imageUrlPropertyName)
            .firstOrNull;

        expect(propertyOrNull, isNotNull);
        expect(propertyOrNull!.value, isA<String>());
        expect(propertyOrNull.value, imageUrl);
      },
    );

    testWidgets(
      'should have correct cacheManager in its properties.',
      (tester) async {
        await tester.pumpWidget(material);

        final properties = widget.toDiagnosticsNode().getProperties();
        final propertyOrNull = properties
            .where((node) => node.name == ImageUrl.cacheManagerPropertyName)
            .firstOrNull;

        expect(propertyOrNull, isNotNull);
        expect(propertyOrNull!.value, isA<BaseCacheManager?>());
        expect(propertyOrNull.value, isNull);
      },
    );

    testWidgets('should display a loading widget.', (tester) async {
      await tester.pumpWidget(material);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(DecoratedBox), findsNothing);
      expect(find.byType(Icons), findsNothing);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ComicCharacterEntity', () {
    test('should be a success when equality is called.', () {
      expect(
        kEntity.equality(),
        (name: kEntity.name, imageUrl: kEntity.imageUrl),
      );
    });

    test('should be a success when hashCode is called.', () {
      expect(
        kEntity.hashCode,
        Object.hash(kEntity.name, kEntity.imageUrl),
      );
    });
  });
}

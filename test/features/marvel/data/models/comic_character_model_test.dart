import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ComicCharacterModel', () {
    test('should have a id getter of type Id from Isar package.', () {
      expect(kModel.id, isA<Id>());
    });

    test('should be a success when the creation is from empty json.', () {
      final json = convertFileToJson(path: 'test/fixtures/empty.json');
      final actual = ComicCharacterModel.fromJson(json);

      expect(actual, kEmptyEntity);
    });

    test('should be a success when the creation is from correct json.', () {
      final json = convertFileToJson(path: 'test/fixtures/model.json');
      final actual = ComicCharacterModel.fromJson(json);

      expect(actual, kModel);
    });

    test('should be a success when the convertor to Json is called.', () {
      final actual = kModel.toJson();

      expect(actual, kModelJson);
    });
  });
}

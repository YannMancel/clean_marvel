import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ComicCharacterModel', () {
    test('should have a local id of type Id from Isar package.', () {
      expect(kModel.localId, isA<Id>());
    });

    test('should be a success when equality is called.', () {
      expect(kModel.equality(), (name: kModel.name, imageUrl: kModel.imageUrl));
    });
  });

  group('ComicCharacterModelExt', () {
    test('should be a success when model is converted to entity.', () {
      expect(kModel.convertToEntity, kEntity);
    });

    test('should be a success when model is cloned with new local id.', () {
      final model = kModel.copyWith(localId: 42);
      expect(model.localId, 42);
      expect(model.name, kModel.name);
      expect(model.imageUrl, kModel.imageUrl);
    });

    test('should be a success when model is cloned with new name.', () {
      final model = kModel.copyWith(name: 'copy name');
      expect(model.localId, kModel.localId);
      expect(model.name, 'copy name');
      expect(model.imageUrl, kModel.imageUrl);
    });

    test('should be a success when model is cloned with new name.', () {
      final model = kModel.copyWith(imageUrl: 'copy image path');
      expect(model.localId, kModel.localId);
      expect(model.name, kModel.name);
      expect(model.imageUrl, 'copy image path');
    });
  });

  group('ComicCharacterModelsExt', () {
    test('should be a success when localIds is called.', () {
      expect(kModels.localIds, <int>[kModel.localId]);
    });

    test('should be a success when convertToEntities is called.', () {
      expect(kModels.convertToEntities, entities);
    });
  });
}

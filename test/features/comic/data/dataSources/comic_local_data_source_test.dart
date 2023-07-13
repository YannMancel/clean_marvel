import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late Isar isar;
  late ComicLocalDataSourceInterface localDataSource;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      <CollectionSchema<dynamic>>[ComicCharacterModelSchema],
      // It will create the following isar files at the project root.
      //  - default.isar
      //  - default.isar.lock
      //  - libisar.dylib
      directory: '',
    );
  });

  tearDownAll(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('ComicLocalDataSource', () {
    setUp(() async {
      localDataSource = ComicLocalDataSource(isar: isar);
    });

    tearDown(() async {
      await isar.writeTxn(
        () async {
          await isar.comicCharacters.clear();
        },
      );
    });

    test(
      'should be a success when isar open the first time (empty list).',
      () async {
        final models = await localDataSource.getComicCharacters();

        expect(models, List<ComicCharacterModel>.empty());
      },
      tags: 'isar',
    );

    test(
      'should be success when models is cached on isar.',
      () async {
        await localDataSource.cacheComicCharacters(kModels);
        final models = await localDataSource.getComicCharacters();

        expect(models, kModels);
      },
      tags: 'isar',
    );
  });
}

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<RemoteApi>(),
  ],
)
import 'comic_character_remote_api_test.mocks.dart';

typedef Converter = JsonConverter<List<ComicCharacterModel>>;

void main() {
  late RemoteApi api;
  late ComicCharacterRemoteApi overLayer;

  group('ComicCharacterRemoteApi', () {
    setUp(() async {
      api = MockRemoteApi();
      overLayer = ComicCharacterRemoteApiImpl(
        remoteApi: api,
      );
    });

    test(
      'should be success when network call get models.',
      () async {
        when(api.get<ComicCharacterModel>(
          endPoint: Endpoints.kComicCharacter,
          queryParameters: anyNamed('queryParameters'),
          on200: (overLayer as Converter).fromJson,
        )).thenAnswer((_) async => kModels);
        final models = await overLayer.getModels();
        expect(models, kModels);
        verify(
          api.get<ComicCharacterModel>(
            endPoint: Endpoints.kComicCharacter,
            queryParameters: anyNamed('queryParameters'),
            on200: (overLayer as Converter).fromJson,
          ),
        ).called(1);
        verifyNoMoreInteractions(api);
      },
    );

    test(
      'should be fail when network call get models '
      '(Unknown failure).',
      () async {
        when(api.get<ComicCharacterModel>(
          endPoint: Endpoints.kComicCharacter,
          queryParameters: anyNamed('queryParameters'),
          on200: (overLayer as Converter).fromJson,
        )).thenThrow(kUnknownFailure);
        final call = overLayer.getModels;
        expect(
          () async => call(),
          throwsA(const TypeMatcher<UnknownFailure>()),
        );
        verify(
          api.get<ComicCharacterModel>(
            endPoint: Endpoints.kComicCharacter,
            queryParameters: anyNamed('queryParameters'),
            on200: (overLayer as Converter).fromJson,
          ),
        ).called(1);
        verifyNoMoreInteractions(api);
      },
    );

    test(
      'should be success when class parses json in models.',
      () async {
        final json = convertFileToJson(path: './test/fixtures/api.json');
        final models = (overLayer as Converter).fromJson(json);
        expect(models, kModels);
        verifyZeroInteractions(api);
      },
    );

    test(
      'should be success when class parses json in models '
      '(empty json).',
      () async {
        final json = convertFileToJson(path: './test/fixtures/empty.json');
        final models = (overLayer as Converter).fromJson(json);
        expect(models, const <ComicCharacterModel>[]);
        verifyZeroInteractions(api);
      },
    );

    test(
      'should be success when class parses json in models '
      '(without results key).',
      () async {
        final json = convertFileToJson(
          path: './test/fixtures/api-with-no-results.json',
        );
        final models = (overLayer as Converter).fromJson(json);
        expect(models, const <ComicCharacterModel>[]);
        verifyZeroInteractions(api);
      },
    );

    test(
      'should be success when class parses json in model.',
      () async {
        final json = convertFileToJson(path: './test/fixtures/model.json');
        final model =
            (overLayer as ComicCharacterRemoteApiImpl).parseModel(json);
        expect(model, kModel);
        verifyZeroInteractions(api);
      },
    );

    test(
      'should be success when class parses json in model '
      '(empty json).',
      () async {
        final json = convertFileToJson(path: './test/fixtures/empty.json');
        final model =
            (overLayer as ComicCharacterRemoteApiImpl).parseModel(json);
        expect(model, kEmptyModel);
        verifyZeroInteractions(api);
      },
    );
  });
}

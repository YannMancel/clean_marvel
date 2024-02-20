import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:dio/dio.dart' as https;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<https.Dio>(as: #MockHttpsDio),
  ],
)
import 'remote_api_test.mocks.dart';

void main() {
  late https.Dio dio;
  late RemoteApi api;

  group('RemoteApi', () {
    setUp(() async {
      dio = MockHttpsDio();
      api = RemoteApiByDio(dio: dio);
    });

    test(
      'should be success when network call return 200 with correct models.',
      () async {
        when(dio.get(
          Endpoints.kComicCharacter,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: const <String, dynamic>{},
              statusCode: 200,
              requestOptions: https.RequestOptions(
                path: Endpoints.kComicCharacter,
              ),
            ));
        final models = await api.get<ComicCharacterModel>(
          endPoint: Endpoints.kComicCharacter,
          on200: (_) => kModels,
        );
        expect(models, kModels);
        verify(
          dio.get(
            Endpoints.kComicCharacter,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'should be success when network call return 200 with no model.',
      () async {
        when(dio.get(
          Endpoints.kComicCharacter,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: const <String, dynamic>{},
              statusCode: 200,
              requestOptions:
                  https.RequestOptions(path: Endpoints.kComicCharacter),
            ));
        final models = await api.get<ComicCharacterModel>(
          endPoint: Endpoints.kComicCharacter,
          on200: (_) => const <ComicCharacterModel>[],
        );
        expect(models, const <ComicCharacterModel>[]);
        verify(
          dio.get(
            Endpoints.kComicCharacter,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'should be fail when network call return 404.',
      () async {
        when(dio.get(
          Endpoints.kComicCharacter,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: const <String, dynamic>{},
              statusCode: 404,
              requestOptions:
                  https.RequestOptions(path: Endpoints.kComicCharacter),
            ));
        final call = api.get<ComicCharacterModel>;
        expect(
          () async => call(
            endPoint: Endpoints.kComicCharacter,
            on200: (_) => const <ComicCharacterModel>[],
          ),
          throwsA(const TypeMatcher<ServerFailure>()),
        );
        verify(
          dio.get(
            Endpoints.kComicCharacter,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'should be fail when network call is fail '
      '(Unknown failure).',
      () async {
        when(dio.get(
          Endpoints.kComicCharacter,
          queryParameters: anyNamed('queryParameters'),
        )).thenThrow(basicException);
        final call = api.get<ComicCharacterModel>;

        expect(
          () async => call(
            endPoint: Endpoints.kComicCharacter,
            on200: (_) => const <ComicCharacterModel>[],
          ),
          throwsA(const TypeMatcher<UnknownFailure>()),
        );
        verify(
          dio.get(
            Endpoints.kComicCharacter,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );
  });
}

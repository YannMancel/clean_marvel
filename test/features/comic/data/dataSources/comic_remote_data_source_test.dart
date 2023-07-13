import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
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
import 'comic_remote_data_source_test.mocks.dart';

void main() {
  late https.Dio httpsClient;
  late ComicRemoteDataSourceInterface remoteDataSource;
  late String endpoint;

  group('ComicRemoteDataSource', () {
    setUp(() async {
      httpsClient = MockHttpsDio();
      remoteDataSource = ComicRemoteDataSource(dio: httpsClient);
      endpoint = (remoteDataSource as ComicRemoteDataSource).charactersEndpoint;
    });

    test('should return a BaseOptions of Dio.', () async {
      expect(ComicRemoteDataSource.options, isA<https.BaseOptions>());
    });

    test(
      'should be success when network call return 200 with correct models.',
      () async {
        final data = convertFileToString(path: 'test/fixtures/api.json');

        when(httpsClient.get(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: data,
              statusCode: 200,
              requestOptions: https.RequestOptions(path: endpoint),
            ));

        final models = await remoteDataSource.getComicCharacters();

        expect(models, kModels);
        verify(
          httpsClient.get(
            endpoint,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(httpsClient);
      },
    );

    test(
      'should be success when network call return 200 with no model '
      '(without data key).',
      () async {
        final data = convertFileToString(path: 'test/fixtures/empty.json');

        when(httpsClient.get(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: data,
              statusCode: 200,
              requestOptions: https.RequestOptions(path: endpoint),
            ));

        final models = await remoteDataSource.getComicCharacters();

        expect(models, List<ComicCharacterModel>.empty());
        verify(
          httpsClient.get(
            endpoint,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(httpsClient);
      },
    );

    test(
      'should be success when network call return 200 with no model '
      '(without results key).',
      () async {
        final data = convertFileToString(
          path: 'test/fixtures/api-with-no-results.json',
        );

        when(httpsClient.get(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: data,
              statusCode: 200,
              requestOptions: https.RequestOptions(path: endpoint),
            ));

        final models = await remoteDataSource.getComicCharacters();

        expect(models, List<ComicCharacterModel>.empty());
        verify(
          httpsClient.get(
            endpoint,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(httpsClient);
      },
    );

    test(
      'should be fail with network call return 404.',
      () async {
        when(httpsClient.get(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => https.Response(
              data: 'FAKE_DATA',
              statusCode: 404,
              requestOptions: https.RequestOptions(path: endpoint),
            ));

        final call = remoteDataSource.getComicCharacters;

        expect(
          () async => call(),
          throwsA(const TypeMatcher<ServerFailure>()),
        );
        verify(
          httpsClient.get(
            endpoint,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(httpsClient);
      },
    );

    test(
      'should be fail when network call is fail.',
      () async {
        when(httpsClient.get(
          endpoint,
          queryParameters: anyNamed('queryParameters'),
        )).thenThrow(basicException);

        final call = remoteDataSource.getComicCharacters;

        expect(
          () async => call(),
          throwsA(const TypeMatcher<UnknownFailure>()),
        );
        verify(
          httpsClient.get(
            endpoint,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).called(1);
        verifyNoMoreInteractions(httpsClient);
      },
    );
  });
}

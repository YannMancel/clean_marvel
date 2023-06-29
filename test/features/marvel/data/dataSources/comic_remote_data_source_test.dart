import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<http.Client>(as: #MockHttpsClient),
  ],
)
import 'comic_remote_data_source_test.mocks.dart';

void main() {
  late http.Client client;
  late ComicRemoteDataSourceInterface remoteDataSource;

  group('ComicRemoteDataSource', () {
    setUp(() async {
      client = MockHttpsClient();
      remoteDataSource = ComicRemoteDataSource(client: client);
    });

    test(
      'should be success when network call return 200 with correct models.',
      () async {
        final uri =
            (remoteDataSource as ComicRemoteDataSource).comicCharacterModelUri;
        final body = convertFileToString(path: 'test/fixtures/api.json');

        when(client.get(uri, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(body, 200));

        final models = await remoteDataSource.getComicCharacters();

        expect(models, <ComicCharacterModel>[kModel]);
        verify(client.get(uri, headers: anyNamed('headers'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should be success when network call return 200 with no model '
      '(without data key).',
      () async {
        final uri =
            (remoteDataSource as ComicRemoteDataSource).comicCharacterModelUri;
        final body = convertFileToString(path: 'test/fixtures/empty.json');

        when(client.get(uri, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(body, 200));

        final models = await remoteDataSource.getComicCharacters();

        expect(models, List<ComicCharacterModel>.empty());
        verify(client.get(uri, headers: anyNamed('headers'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should be success when network call return 200 with no model '
      '(without results key).',
      () async {
        final uri =
            (remoteDataSource as ComicRemoteDataSource).comicCharacterModelUri;
        final body = convertFileToString(
          path: 'test/fixtures/api-with-no-results.json',
        );

        when(client.get(uri, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(body, 200));

        final models = await remoteDataSource.getComicCharacters();

        expect(models, List<ComicCharacterModel>.empty());
        verify(client.get(uri, headers: anyNamed('headers'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should be fail with network call return 404.',
      () async {
        final uri =
            (remoteDataSource as ComicRemoteDataSource).comicCharacterModelUri;

        when(client.get(uri, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('FAKE_BODY', 404));

        final call = remoteDataSource.getComicCharacters;

        expect(() async => call(), throwsA(const TypeMatcher<Failure>()));
        verify(client.get(uri, headers: anyNamed('headers'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should be fail when network call is fail.',
      () async {
        final uri =
            (remoteDataSource as ComicRemoteDataSource).comicCharacterModelUri;

        when(client.get(uri, headers: anyNamed('headers')))
            .thenThrow(basicException);

        final call = remoteDataSource.getComicCharacters;

        expect(() async => call(), throwsA(const TypeMatcher<Failure>()));
        verify(client.get(uri, headers: anyNamed('headers'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
}

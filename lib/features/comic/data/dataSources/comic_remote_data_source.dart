import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:dio/dio.dart' as https;

/// The data source allows to manage in remote way.
///
/// ```dart
/// final dio = https.Dio()..options = ComicRemoteDataSource.options;
/// final remoteDataSource = ComicRemoteDataSource(dio: dio);
/// ```
class ComicRemoteDataSource implements ComicRemoteDataSourceInterface {
  ComicRemoteDataSource({required https.Dio dio}) : _dio = dio;

  final https.Dio _dio;

  static https.BaseOptions options = https.BaseOptions(
    baseUrl: Api.kBaseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );

  List<ComicCharacterModel> _parseModelsByResponse(https.Response response) {
    switch (response.statusCode) {
      case 200:
        final json = response.data as Map<String, dynamic>;

        final kDataKey = Api.kCharacters.kJson.kData;
        if (!json.containsKey(kDataKey)) {
          return List<ComicCharacterModel>.empty();
        }
        final data = json[kDataKey]! as Map<String, dynamic>;

        final kResultsKey = Api.kCharacters.kJson.kResults;
        if (!data.containsKey(kResultsKey)) {
          return List<ComicCharacterModel>.empty();
        }
        final results = data[kResultsKey]! as List<dynamic>;

        return results
            .map(
              (e) => ComicCharacterModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(growable: false);

      default:
        throw const Failure.server();
    }
  }

  @override
  Future<List<ComicCharacterModel>> getComicCharacters() async {
    try {
      final response = await _dio.get(
        Api.kCharacters.kEndpoint,
        queryParameters: <String, dynamic>{
          Api.kCharacters.kQueryParameters.kTimestamp: kTimestampFromEnv,
          Api.kCharacters.kQueryParameters.kApikey: kApikeyFromEnv,
          Api.kCharacters.kQueryParameters.kHash: kHashFromEnv,
        },
      );

      return _parseModelsByResponse(response);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const Failure.unknown();
    }
  }
}

import 'dart:convert';

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:dio/dio.dart' as https;
import 'package:flutter/foundation.dart';

/// The data source allows to manage in remote way.
///
/// ```dart
/// final dio = https.Dio()..options = ComicRemoteDataSource.options;
///
/// final remoteDataSource = ComicRemoteDataSource(dio: dio);
/// ```
class ComicRemoteDataSource implements ComicRemoteDataSourceInterface {
  ComicRemoteDataSource({required https.Dio dio}) : _dio = dio;

  final https.Dio _dio;

  static https.BaseOptions options = https.BaseOptions(
    baseUrl: 'https://gateway.marvel.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );

  @visibleForTesting
  String get charactersEndpoint => '/v1/public/characters';

  List<ComicCharacterModel> _parseModelsByResponse(https.Response response) {
    switch (response.statusCode) {
      case 200:
        final json = jsonDecode(response.data) as Map<String, dynamic>;

        if (!json.containsKey('data')) {
          return List<ComicCharacterModel>.empty();
        }
        final data = json['data']! as Map<String, dynamic>;

        if (!data.containsKey('results')) {
          return List<ComicCharacterModel>.empty();
        }
        final results = data['results']! as List<dynamic>;

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
        charactersEndpoint,
        queryParameters: const <String, dynamic>{
          'ts': String.fromEnvironment(
            'TIMESTAMP',
            defaultValue: '[TIMESTAMP]',
          ),
          'apikey': String.fromEnvironment(
            'API_KEY',
            defaultValue: '[API_KEY]',
          ),
          'hash': String.fromEnvironment(
            'HASH',
            defaultValue: '[HASH]',
          ),
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

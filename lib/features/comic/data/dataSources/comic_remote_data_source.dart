import 'dart:convert';

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// The data source allows to manage in remote way.
///
/// ```dart
/// final client = http.Client();
/// final remoteDataSource = ComicRemoteDataSource(client: client);
/// ```
class ComicRemoteDataSource implements ComicRemoteDataSourceInterface {
  const ComicRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  static const kBaseUrl = 'gateway.marvel.com';
  static const kCharactersEndPoint = '/v1/public/characters';
  static const kHeaders = <String, String>{'Content-Type': 'application/json'};
  static const kTimestamp = String.fromEnvironment(
    'TIMESTAMP',
    defaultValue: '[TIMESTAMP]',
  );
  static const kApikey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '[API_KEY]',
  );
  static const kHash = String.fromEnvironment(
    'HASH',
    defaultValue: '[HASH]',
  );

  @visibleForTesting
  Uri get comicCharacterModelUri {
    return Uri.https(
      kBaseUrl,
      kCharactersEndPoint,
      const <String, dynamic>{
        'ts': kTimestamp,
        'apikey': kApikey,
        'hash': kHash,
      },
    );
  }

  List<ComicCharacterModel> _parseModelsByResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final json = jsonDecode(response.body) as Map<String, dynamic>;

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
      final response = await _client.get(
        comicCharacterModelUri,
        headers: kHeaders,
      );

      return _parseModelsByResponse(response);
    } on Failure catch (_) {
      rethrow;
    } catch (_) {
      throw const Failure.unknown();
    }
  }
}

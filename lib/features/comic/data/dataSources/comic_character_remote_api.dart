import 'package:clean_marvel/features/_features.dart';
import 'package:flutter/foundation.dart';

/// **Responsibility**: Group together all the useful actions of a network call
/// for [ComicCharacterModel].
abstract interface class ComicCharacterRemoteApi {
  Future<List<ComicCharacterModel>> getModels();
}

class ComicCharacterRemoteApiImpl
    implements
        ComicCharacterRemoteApi,
        JsonConverter<List<ComicCharacterModel>> {
  ComicCharacterRemoteApiImpl({
    required RemoteApi remoteApi,
  }) : _remoteApi = remoteApi;

  final RemoteApi _remoteApi;

  @override
  @visibleForTesting
  List<ComicCharacterModel> fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('data')) return const <ComicCharacterModel>[];
    final data = json['data']! as Map<String, dynamic>;

    if (!data.containsKey('results')) return const <ComicCharacterModel>[];
    final results = data['results']! as List<dynamic>;

    return <ComicCharacterModel>[
      for (final result in results) parseModel(result as Map<String, dynamic>),
    ];
  }

  @visibleForTesting
  ComicCharacterModel parseModel(Map<String, dynamic> json) {
    final name = json['name'] ?? '';
    final thumbnail = json['thumbnail'] as Map<String, dynamic>?;
    final hasPathKey = thumbnail?.containsKey('path') ?? false;
    final hasExtensionKey = thumbnail?.containsKey('extension') ?? false;
    final imageUrl = hasPathKey && hasExtensionKey
        ? '${thumbnail!['path']}.${thumbnail['extension']}'
        : '';

    return ComicCharacterModel(
      name: name,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<List<ComicCharacterModel>> getModels() async {
    return _remoteApi.get(
      endPoint: '/v1/public/characters',
      queryParameters: const <String, dynamic>{
        'ts': String.fromEnvironment('TIMESTAMP'),
        'apikey': String.fromEnvironment('API_KEY'),
        'hash': String.fromEnvironment('HASH'),
      },
      on200: fromJson,
    );
  }
}

abstract class Api {
  static const kBaseUrl = 'https://gateway.marvel.com';
  static const kCharacters = _Characters();
}

class _Characters {
  const _Characters();

  String get kEndpoint => '/v1/public/characters';
  _QueryParameters get kQueryParameters => const _QueryParameters();
  _Json get kJson => const _Json();
}

class _QueryParameters {
  const _QueryParameters();

  String get kTimestamp => 'ts';
  String get kApikey => 'apikey';
  String get kHash => 'hash';
}

class _Json {
  const _Json();

  String get kData => 'data';
  String get kResults => 'results';
  String get kName => 'name';
  String get kThumbnail => 'thumbnail';
  String get kPath => 'path';
  String get kExtension => 'extension';
}

// [ENVIRONMENT]
const kTimestampFromEnv = String.fromEnvironment('TIMESTAMP');
const kApikeyFromEnv = String.fromEnvironment('API_KEY');
const kHashFromEnv = String.fromEnvironment('HASH');

// [ISAR]
const kComicCharacters = 'comicCharacters';

// [TO JSON]
const kImageUrl = 'imageUrl';

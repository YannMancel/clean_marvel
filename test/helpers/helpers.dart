import 'dart:convert' as json;
import 'dart:io';

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';

// CONVERTOR -------------------------------------------------------------------
String convertFileToString({required String path}) {
  return File(path).readAsStringSync();
}

Map<String, dynamic> convertFileToJson({required String path}) {
  final source = convertFileToString(path: path);
  return json.jsonDecode(source) as Map<String, dynamic>;
}

// MODEL -----------------------------------------------------------------------
const kModel = ComicCharacterModel(
  localId: 42,
  name: '3-D Man',
  imageUrl: 'http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg',
);
const kEmptyModel = ComicCharacterModel(
  name: '',
  imageUrl: '',
);
const kModels = <ComicCharacterModel>[kModel];

// ENTITY ----------------------------------------------------------------------
const kEntity = ComicCharacterEntity(
  name: '3-D Man',
  imageUrl: 'http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg',
);
final entities = <ComicCharacterEntity>[kEntity];

// ERROR -----------------------------------------------------------------------
final basicException = Exception();
const kUnknownFailure = Failure.unknown();
const kCacheFailure = Failure.cache();
const kServerFailure = Failure.server();

// RESULT ----------------------------------------------------------------------
final resultOfData = Result<List<ComicCharacterEntity>>.data(entities);
Result<List<ComicCharacterEntity>> resultOfError({
  required Exception exception,
}) {
  return Result<List<ComicCharacterEntity>>.error(exception: exception);
}

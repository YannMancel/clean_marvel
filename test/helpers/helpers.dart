import 'dart:convert' as json;
import 'dart:io';

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/data/_data.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';

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
  name: '3-D Man',
  imageUrl: 'http://i.annihil.us/u/prod/marvel/i/mg/c/e0/'
      '535fecbbb9784.jpg',
);
const kModels = <ComicCharacterModel>[kModel];
const kModelJson = <String, dynamic>{
  'name': '3-D Man',
  'imageUrl': 'http://i.annihil.us/u/prod/marvel/i/mg/c/e0/'
      '535fecbbb9784.jpg',
};

// ENTITY ----------------------------------------------------------------------
const kEmptyEntity = ComicCharacterModel(
  name: '',
  imageUrl: '',
);
final entity = kModel.convertToEntity;
final entities = kModels.map((model) => model.convertToEntity).toList();

// ERROR -----------------------------------------------------------------------
final basicException = Exception();
const kUnknownFailure = Failure.unknown();
const kCacheFailure = Failure.cache();
const kServerFailure = Failure.server();

// RESULT ----------------------------------------------------------------------
final resultOfData = Result<List<ComicCharacterEntity>>.data(entities);
final resultOfErrorWithBasicException =
    Result<List<ComicCharacterEntity>>.error(exception: basicException);
const kResultOfErrorWithUnknownFailure =
    Result<List<ComicCharacterEntity>>.error(exception: kUnknownFailure);
const kResultOfErrorWithServerFailure =
    Result<List<ComicCharacterEntity>>.error(exception: kServerFailure);
const kResultOfErrorWithCacheFailure =
    Result<List<ComicCharacterEntity>>.error(exception: kCacheFailure);

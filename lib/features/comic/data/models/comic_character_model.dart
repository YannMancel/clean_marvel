import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'comic_character_model.freezed.dart';
part 'comic_character_model.g.dart';

@freezed
@Collection(
  accessor: kComicCharacters,
  ignore: {
    'copyWith',
    'convertToEntity',
  },
)
class ComicCharacterModel with _$ComicCharacterModel {
  const ComicCharacterModel._();

  const factory ComicCharacterModel({
    required String name,
    required String imageUrl,
  }) = _Model;

  factory ComicCharacterModel.fromJson(Map<String, dynamic> json) {
    final kNameKey = Api.kCharacters.kJson.kName;
    final kThumbnailKey = Api.kCharacters.kJson.kThumbnail;
    final kPathKey = Api.kCharacters.kJson.kPath;
    final kExtensionKey = Api.kCharacters.kJson.kExtension;

    final name = json[kNameKey] ?? '';
    final thumbnailOrNull = json[kThumbnailKey] as Map<String, dynamic>?;
    final hasPathKey = thumbnailOrNull?.containsKey(kPathKey) ?? false;
    final hasExtensionKey =
        thumbnailOrNull?.containsKey(kExtensionKey) ?? false;
    final imageUrl = hasPathKey && hasExtensionKey
        ? '${thumbnailOrNull![kPathKey]}.${thumbnailOrNull[kExtensionKey]}'
        : '';

    return ComicCharacterModel(
      name: name,
      imageUrl: imageUrl,
    );
  }

  Id get id => Isar.autoIncrement;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Api.kCharacters.kJson.kName: name,
      kImageUrl: imageUrl,
    };
  }

  ComicCharacterEntity get convertToEntity {
    return ComicCharacterEntity(
      name: name,
      imageUrl: imageUrl,
    );
  }
}

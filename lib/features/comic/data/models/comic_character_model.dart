import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'comic_character_model.freezed.dart';
part 'comic_character_model.g.dart';

@freezed
@Collection(
  accessor: 'comicCharacters',
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
    final name = json['name'] ?? '';
    final thumbnailOrNull = json['thumbnail'] as Map<String, dynamic>?;
    final hasPathKey = thumbnailOrNull?.containsKey('path') ?? false;
    final hasExtensionKey = thumbnailOrNull?.containsKey('extension') ?? false;
    final imageUrl = hasPathKey && hasExtensionKey
        ? '${thumbnailOrNull!['path']}.${thumbnailOrNull['extension']}'
        : '';

    return ComicCharacterModel(
      name: name,
      imageUrl: imageUrl,
    );
  }

  Id get id => Isar.autoIncrement;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  ComicCharacterEntity get convertToEntity {
    return ComicCharacterEntity(
      name: name,
      imageUrl: imageUrl,
    );
  }
}

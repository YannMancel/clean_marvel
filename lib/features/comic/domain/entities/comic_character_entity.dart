import 'package:freezed_annotation/freezed_annotation.dart';

part 'comic_character_entity.freezed.dart';

@freezed
class ComicCharacterEntity with _$ComicCharacterEntity {
  const factory ComicCharacterEntity({
    required String name,
    required String imageUrl,
  }) = _Entity;
}

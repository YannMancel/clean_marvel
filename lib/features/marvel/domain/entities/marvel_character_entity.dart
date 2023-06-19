import 'package:freezed_annotation/freezed_annotation.dart';

part 'marvel_character_entity.freezed.dart';

@freezed
class MarvelCharacterEntity with _$MarvelCharacterEntity {
  const factory MarvelCharacterEntity({
    required String name,
    required String imageUrl,
  }) = _Entity;
}

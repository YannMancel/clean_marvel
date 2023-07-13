import 'package:clean_marvel/features/comic/domain/_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comic_characters_state.freezed.dart';

@freezed
class ComicCharactersState with _$ComicCharactersState {
  const factory ComicCharactersState.loading() = _Loading;
  const factory ComicCharactersState.data({
    @Default(<ComicCharacterEntity>[]) List<ComicCharacterEntity> entities,
  }) = _Data;
  const factory ComicCharactersState.error({
    required Exception exception,
  }) = _Error;
}

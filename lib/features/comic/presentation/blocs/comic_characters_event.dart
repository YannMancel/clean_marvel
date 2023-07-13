import 'package:freezed_annotation/freezed_annotation.dart';

part 'comic_characters_event.freezed.dart';

@freezed
class ComicCharactersEvent with _$ComicCharactersEvent {
  const factory ComicCharactersEvent.started() = StartedEvent;
  const factory ComicCharactersEvent.refreshed() = RefreshedEvent;
}

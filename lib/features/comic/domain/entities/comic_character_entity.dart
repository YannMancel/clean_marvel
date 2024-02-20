import 'package:freezed_annotation/freezed_annotation.dart';

class ComicCharacterEntity {
  const ComicCharacterEntity({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;

  @visibleForTesting
  ({String name, String imageUrl}) equality() {
    return (name: name, imageUrl: imageUrl);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ComicCharacterEntity && equality() == other.equality());
  }

  @override
  int get hashCode => Object.hash(name, imageUrl);
}

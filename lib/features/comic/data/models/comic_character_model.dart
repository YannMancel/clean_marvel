import 'package:clean_marvel/features/_features.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

part 'comic_character_model.g.dart';

@Collection(
  ignore: <String>{
    'equality',
    'hashCode',
  },
)
@Name("comic_characters")
class ComicCharacterModel {
  const ComicCharacterModel({
    this.localId = Isar.autoIncrement,
    required this.name,
    required this.imageUrl,
  });

  @Name("id")
  final Id localId;
  @Index(unique: true)
  final String name;
  @Name("image_url")
  final String imageUrl;

  // id is not take into account in equality.
  // It not important for network api.
  @visibleForTesting
  ({String name, String imageUrl}) equality() {
    return (name: name, imageUrl: imageUrl);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ComicCharacterModel && equality() == other.equality());
  }

  @override
  int get hashCode => Object.hash(name, imageUrl);
}

extension ComicCharacterModelExt on ComicCharacterModel {
  ComicCharacterEntity get convertToEntity {
    return ComicCharacterEntity(
      name: name,
      imageUrl: imageUrl,
    );
  }

  ComicCharacterModel copyWith({
    Id? localId,
    String? name,
    String? imageUrl,
  }) {
    return ComicCharacterModel(
      localId: localId ?? this.localId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

extension ComicCharacterModelsExt on List<ComicCharacterModel> {
  List<Id> get localIds {
    return <Id>[
      for (final model in this) model.localId,
    ];
  }

  List<ComicCharacterEntity> get convertToEntities {
    return <ComicCharacterEntity>[
      for (final model in this) model.convertToEntity,
    ];
  }
}

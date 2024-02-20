import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComicCharactersWidget extends StatelessWidget {
  const ComicCharactersWidget(
    List<ComicCharacterEntity> entities, {
    super.key,
  }) : _entities = entities;

  final List<ComicCharacterEntity> _entities;

  @visibleForTesting
  static const entitiesPropertyName = 'entities';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      IterableProperty(entitiesPropertyName, _entities),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_entities.isEmpty) {
      return Semantics(
        label: "Maestro - No entity",
        child: ScrollViewWithOnlyOneWidget(
          builder: (_) => const Text('No data'),
        ),
      );
    }

    return Semantics(
      label: "Maestro - Entities",
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        itemCount: _entities.length,
        itemBuilder: (_, index) {
          final entity = _entities[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ComicCharacterCard(entity, key: ObjectKey(entity)),
          );
        },
      ),
    );
  }
}

import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComicCharacterCard extends StatelessWidget {
  const ComicCharacterCard(
    ComicCharacterEntity entity, {
    super.key,
  }) : _entity = entity;

  final ComicCharacterEntity _entity;

  @visibleForTesting
  static const entityPropertyName = 'entity';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ComicCharacterEntity>(entityPropertyName, _entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: ImageUrl(_entity.imageUrl),
          ),
          Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(color: Colors.black),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _entity.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

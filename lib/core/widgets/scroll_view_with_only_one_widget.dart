import 'package:clean_marvel/core/_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScrollViewWithOnlyOneWidget extends StatelessWidget {
  const ScrollViewWithOnlyOneWidget({
    super.key,
    required WidgetBuilder builder,
  }) : _builder = builder;

  final WidgetBuilder _builder;

  @visibleForTesting
  static const builderPropertyName = 'builder';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<WidgetBuilder>(builderPropertyName, _builder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: context.bodyHeight,
        child: Center(
          child: _builder(context),
        ),
      ),
    );
  }
}

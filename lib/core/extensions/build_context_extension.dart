import 'package:flutter/material.dart';

extension BuildCOntextExtension on BuildContext {
  double get bodyHeight {
    return MediaQuery.of(this).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight;
  }
}

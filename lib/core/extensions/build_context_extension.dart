import 'package:flutter/material.dart';

extension BuildCOntextExtension on BuildContext {
  double get bodyHeight {
    return MediaQuery.sizeOf(this).height -
        kToolbarHeight -
        kBottomNavigationBarHeight;
  }
}

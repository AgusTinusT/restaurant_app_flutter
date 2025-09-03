import 'package:flutter/material.dart';

class AppBarProvider extends ChangeNotifier {
  Color _appBarColor = Colors.transparent;
  double _appBarElevation = 0;

  Color get appBarColor => _appBarColor;
  double get appBarElevation => _appBarElevation;

  void onScroll(ScrollNotification scrollInfo, BuildContext context) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      final primaryColor = Theme.of(context).colorScheme.primary;
      const scrollStart = 100.0;
      const scrollEnd = 200.0;

      final pixels = scrollInfo.metrics.pixels;
      double opacity = 0.0;
      if (pixels > scrollStart) {
        opacity = (pixels - scrollStart) / (scrollEnd - scrollStart);
      }
      opacity = opacity.clamp(0.0, 1.0);

      final newAppBarColor = primaryColor.withValues(alpha: opacity);
      final newElevation = opacity > 0.9 ? 4.0 : 0.0;

      if (newAppBarColor != _appBarColor || newElevation != _appBarElevation) {
        _appBarColor = newAppBarColor;
        _appBarElevation = newElevation;
        if (hasListeners) {
          notifyListeners();
        }
      }
    }
  }
}

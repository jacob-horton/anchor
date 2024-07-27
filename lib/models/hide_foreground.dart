import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HideForegroundModel extends ChangeNotifier {
  bool _hideForeground = false;
  bool get hideForeground => _hideForeground;

  void toggleHideForeground() {
    _hideForeground = !_hideForeground;

    if (_hideForeground) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    notifyListeners();
  }
}

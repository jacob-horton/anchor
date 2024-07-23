import 'package:flutter/material.dart';

class HideForegroundModel extends ChangeNotifier {
  bool _hideForeground = false;
  bool get hideForeground => _hideForeground;

  void toggleHideForeground() {
    _hideForeground = !_hideForeground;
    notifyListeners();
  }
}

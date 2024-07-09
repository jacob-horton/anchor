import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundModel extends ChangeNotifier {
  String _filename = 'nature.jpg';
  late final SharedPreferences _prefs;

  BackgroundModel() {
    _loadPrefs();
  }

  _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String? filename = _prefs.getString('background');
    if (filename != null) {
      _filename = filename;
      notifyListeners();
    }
  }

  /// An unmodifiable view of the items in the cart.
  String get path => 'images/$_filename';

  void updatePath(String filename) {
    _filename = filename;
    print(filename);
    _prefs.setString('background', filename);
    notifyListeners();
  }
}

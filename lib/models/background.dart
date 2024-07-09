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

  String get path => 'images/$_filename';

  void updateFilename(String filename) {
    _filename = filename;
    _prefs.setString('background', filename);
    notifyListeners();
  }
}

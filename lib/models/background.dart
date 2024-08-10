import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundModel extends ChangeNotifier {
  String _filepath = 'assets/images/northern-lights.jpg';
  bool _isAsset = true;

  late final SharedPreferences _prefs;

  BackgroundModel() {
    _loadPrefs();
  }

  _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String? filename = _prefs.getString('background');
    if (filename != null) {
      _filepath = filename;
    }

    bool? isAsset = _prefs.getBool('background-is-asset');
    if (isAsset != null) {
      _isAsset = isAsset;
    }

    notifyListeners();
  }

  String get path => _filepath;
  bool get isAsset => _isAsset;

  void _cleanUpCustomImage() async {
    if (!_isAsset) {
      File(_filepath).delete();
    }
  }

  void setToAsset(String filename) {
    _cleanUpCustomImage();

    _filepath = filename;
    _isAsset = true;

    _prefs.setString('background', filename);
    _prefs.setBool('background-is-asset', true);

    notifyListeners();
  }

  void setToCustomImage(String path) {
    _cleanUpCustomImage();

    _filepath = path;
    _isAsset = false;

    _prefs.setString('background', path);
    _prefs.setBool('background-is-asset', false);

    notifyListeners();
  }
}

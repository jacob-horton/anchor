import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameModel extends ChangeNotifier {
  String _username = 'User';
  late final SharedPreferences _prefs;

  UsernameModel() {
    _loadPrefs();
  }

  _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String? username = _prefs.getString('username');
    if (username != null) {
      _username = username;
      notifyListeners();
    }
  }

  String get username => _username;

  set username(String username) {
    _username = username;
    _prefs.setString('username', username);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesModel extends ChangeNotifier {
  List<String> _favourites = [];
  late final SharedPreferences _prefs;

  FavouritesModel() {
    _loadPrefs();
  }

  _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? favourites = _prefs.getStringList('favourites');
    if (favourites != null) {
      _favourites = favourites;
      notifyListeners();
    }
  }

  List<String> get favourites => _favourites;

  bool isFavourite(String trackName) => _favourites.contains(trackName);

  void addFavourite(String trackName) {
    // TODO: remove duplicates
    _favourites.add(trackName);
    _prefs.setStringList('favourites', _favourites);

    notifyListeners();
  }

  void removeFavourite(String trackName) {
    _favourites.remove(trackName);
    _prefs.setStringList('favourites', _favourites);

    notifyListeners();
  }
}

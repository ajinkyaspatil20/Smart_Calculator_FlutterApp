import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favorites = {};
  final String _prefsKey = 'favorites';

  FavoritesProvider() {
    _loadFavorites();
  }

  Set<String> get favorites => _favorites;

  bool isFavorite(String formula) => _favorites.contains(formula);

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_prefsKey) ?? [];
    _favorites.addAll(favoritesList);
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favorites.toList());
  }

  void toggleFavorite(String formula) {
    if (_favorites.contains(formula)) {
      _favorites.remove(formula);
    } else {
      _favorites.add(formula);
    }
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(String formula) {
    _favorites.remove(formula);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
    notifyListeners();
  }
}

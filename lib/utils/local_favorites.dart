import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalFavorites {
  static const _key = 'favorites';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_key) ?? [];
    return favoritesJson
        .map((json) => jsonDecode(json))
        .cast<String>()
        .toList();
  }

  static Future<void> toggleFavorite(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();

    if (favorites.contains(imageUrl)) {
      favorites.remove(imageUrl);
    } else {
      favorites.add(imageUrl);
    }

    final favoritesJson =
        favorites.map((imageUrl) => jsonEncode(imageUrl)).toList();
    prefs.setStringList(_key, favoritesJson);
  }
}

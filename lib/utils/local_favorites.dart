import 'dart:convert';
import 'package:flutter/material.dart';
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

  static bool isFavorite = false;

  static Future<bool> favIcon(String imageUrl) async {
    List<String> favorites = await getFavorites();
    if (favorites.contains(imageUrl)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> toggleFavorite(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();

    if (favorites.contains(imageUrl)) {
      favorites.remove(imageUrl);
      isFavorite = false;
    } else {
      favorites.add(imageUrl);
      isFavorite = true;
    }

    final favoritesJson =
        favorites.map((imageUrl) => jsonEncode(imageUrl)).toList();
    prefs.setStringList(_key, favoritesJson);
  }

  static Stream<List<String>> favoritesStream() async* {
    while (true) {
      yield await getFavorites();
      await Future.delayed(
          const Duration(seconds: 1)); // Adjust the delay as needed
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_location.dart';

class SavedLocationsProvider with ChangeNotifier {
  static const String _storageKey = 'saved_locations';
  final List<SavedLocation> _savedLocations = [];

  List<SavedLocation> get savedLocations => List.of(_savedLocations);

  bool isSaved(int id) {
    return _savedLocations.any((savedLoc) => savedLoc.location.id == id);
  }

  Future<void> loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return;

    final List<dynamic> decoded = jsonDecode(jsonString);
    _savedLocations
      ..clear()
      ..addAll(decoded.map((item) => SavedLocation.fromJson(item)));
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      _savedLocations.map((loc) => loc.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }

  void addLocation(SavedLocation savedLoc) {
    if (isSaved(savedLoc.location.id)) {
      if (savedLoc.location.id == -888) {
        final index = _savedLocations.indexWhere(
          (loc) => loc.location.id == -888,
        );
        _savedLocations[index] =
            savedLoc; // replace the whole entry: new coords + new name
        notifyListeners();
        _persist();
      }
      return;
    }
    _savedLocations.add(savedLoc);
    notifyListeners();
    _persist();
  }

  void renameLocation(int id, String newName) {
    final index = _savedLocations.indexWhere(
      (element) => element.location.id == id,
    );
    if (index == -1) return; // not found, nothing to rename
    _savedLocations[index].displayName = newName;
    notifyListeners();
    _persist();
  }

  void removeLocation(int id) {
    _savedLocations.removeWhere((savedLoc) => savedLoc.location.id == id);
    notifyListeners();
    _persist();
  }
}

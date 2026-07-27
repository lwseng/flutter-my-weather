import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/string_constants.dart';
import '../models/weather_data.dart';
import '../models/location_data.dart';
import '../models/saved_location.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';

class WeatherProvider with ChangeNotifier {
  final _weatherService = WeatherApiService();
  final _locationService = LocationService();

  static const String _storageKey = 'is_celsius';
  static const String _lastSelectedKey = 'last_selected_location_id';
  static const double _defaultLat = 3.1390;
  static const double _defaultLon = 101.6869;
  String _locationName = 'Kuala Lumpur';
  String _locationInfo = StringConstants.defaultLocationTitle;
  bool _isDeviceLocationAvailable = false;
  WeatherData? _weatherData;
  int? _selectedLocationId;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isCelsius = true;

  String get locationName => _locationName;
  String get locationInfo => _locationInfo;
  bool get isDeviceLocationAvailable => _isDeviceLocationAvailable;
  WeatherData? get weatherData => _weatherData;
  int? get selectedLocationId => _selectedLocationId;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isCelsius => _isCelsius;

  Future<void> _persistSelectedLocation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSelectedKey, id);
  }

  Future<SavedLocation?> refreshCurrentLocationEntry() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final locationName = await _locationService.getCurrentLocationName(
        position.latitude,
        position.longitude,
      );
      return SavedLocation(
        location: Location(
          id: -888,
          name: locationName,
          latitude: position.latitude,
          longitude: position.longitude,
          country: 'Your Current Location',
          state: '',
          timezone: '',
        ),
        isCurrentLocation: true,
      );
    } catch (_) {
      return null; // couldn't get a fresh fix — leave the old entry as-is
    }
  }

  Future<SavedLocation?> fetchWeatherForCurrentPosition() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    //Default Kuala Lumpur
    double lat = _defaultLat;
    double lon = _defaultLon;
    try {
      final position = await _locationService.getCurrentPosition();
      lat = position.latitude;
      lon = position.longitude;

      final locationName = await _locationService.getCurrentLocationName(
        lat,
        lon,
      );

      final currentLocation = SavedLocation(
        location: Location(
          id: -888,
          name: locationName,
          latitude: lat,
          longitude: lon,
          country: 'Your Current Location',
          state: '',
          timezone: '',
        ),
        isCurrentLocation: true,
      );
      _selectedLocationId = currentLocation.location.id;
      _locationName = locationName;
      _locationInfo = StringConstants.myLocationTitle;
      _isDeviceLocationAvailable = true;

      await fetchWeather(lat, lon);
      await _persistSelectedLocation(-888);
      return currentLocation;
    } catch (error) {
      _locationName = 'Kuala Lumpur';
      _isDeviceLocationAvailable = false;
      await fetchWeather(lat, lon);
      return null;
    }
  }

  Future<void> fetchWeatherForSavedPosition(SavedLocation savedLoc) async {
    _selectedLocationId = savedLoc.location.id;
    _locationName = savedLoc.displayName;
    _locationInfo = savedLoc.location.id == -888
        ? StringConstants.myLocationTitle
        : StringConstants.savedLocationTitle;

    notifyListeners();

    await fetchWeather(savedLoc.location.latitude, savedLoc.location.longitude);
    await _persistSelectedLocation(savedLoc.location.id);
  }

  Future<SavedLocation?> restoreLastSelection(
    List<SavedLocation> savedLocations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getInt(_lastSelectedKey);

    if (lastId == null || lastId == -888) {
      return await fetchWeatherForCurrentPosition();
    }

    final matches = savedLocations.where((loc) => loc.location.id == lastId);
    if (matches.isEmpty) {
      return await fetchWeatherForCurrentPosition();
    }

    await fetchWeatherForSavedPosition(
      matches.first,
    ); // displays the saved location, as before
    return await refreshCurrentLocationEntry(); // silently refreshes "My Location" in the background
  }

  Future<void> fetchWeather(double lat, double lon) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _weatherData = await _weatherService.getCurrentWeather(lat, lon);
    } catch (error) {
      _errorMessage = StringConstants.genericErrorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocationName(String name) {
    _locationName = name;
    notifyListeners();
  }

  Future<void> loadUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isCelsius = prefs.getBool(_storageKey) ?? true;
    notifyListeners();
  }

  void setInitialUnit(bool isCelsius) {
    _isCelsius = isCelsius;
  }

  void toggleUnit() async {
    _isCelsius = !_isCelsius;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, _isCelsius);
  }
}

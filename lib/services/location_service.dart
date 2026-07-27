import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  final _geocoding = Geocoding();

  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw LocationServiceException('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationServiceException('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: .high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  Future<String> getCurrentLocationName(double lat, double lon) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(lat, lon);
      if (placemarks.isEmpty) return 'Unknown location';

      final place = placemarks.first;
      return (place.locality == place.administrativeArea)
          ? '${place.locality}'
          : '${place.locality}, ${place.administrativeArea}';
    } catch (_) {
      return 'Unknown location';
    }
  }
}

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => message;
}

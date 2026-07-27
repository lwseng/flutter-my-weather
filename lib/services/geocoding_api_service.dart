// services/geocoding_api_service.dart
import '../constants/api_constants.dart';
import '../models/location_data.dart';
import 'api_client.dart';

class GeocodingApiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Location>> searchCity(String cityName, {int count = 100}) async {
    final url = '${ApiConstants.geocodingSearch}?name=$cityName&count=$count';

    final data = await _apiClient.get(url);
    final List results = data['results'] ?? [];

    List<Location> locations = [];

    for (var item in results) {
      locations.add(
        Location(
          id: item['id'],
          name: item['name'],
          latitude: item['latitude'],
          longitude: item['longitude'],
          country: item['country'] ?? '',
          state: item['admin1'] ?? '',
          timezone: item['timezone'] ?? '',
        ),
      );
    }
    return locations;
  }
}

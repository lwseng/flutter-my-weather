import '../constants/api_constants.dart';
import '../models/current_weather.dart';
import '../models/weather_data.dart';
import '../models/daily_forecast.dart';
import '../models/hourly_forecast.dart';

import 'api_client.dart';

class WeatherApiService {
  final ApiClient _apiClient = ApiClient();

  Future<WeatherData> getCurrentWeather(double lat, double lon) async {
    final url =
        '${ApiConstants.forecast}?latitude=$lat&longitude=$lon&timezone=auto&'
        '&current=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m'
        '&hourly=temperature_2m,weather_code&forecast_hours=24'
        '&daily=temperature_2m_max,temperature_2m_min,weather_code';

    final data = await _apiClient.get(url);
    final current = _parseCurrentWeather(data['current']);
    final hourly = _parseHourlyForecast(data['hourly']);
    final daily = _parseDailyForecast(data['daily']);

    return WeatherData(current: current, hourly: hourly, daily: daily);
  }

  CurrentWeather _parseCurrentWeather(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'],
      temperature: json['temperature_2m'],
      weatherCode: WeatherCondition.fromCode(json['weather_code']),
      windSpeed: json['wind_speed_10m'],
      humidity: json['relative_humidity_2m'],
    );
  }

  List<HourlyForecast> _parseHourlyForecast(Map<String, dynamic> json) {
    List times = json['time'];
    List temps = json['temperature_2m'];
    List codes = json['weather_code'];

    final now = DateTime.now();
    final currentHour = DateTime(now.year, now.month, now.day, now.hour); // truncate to hour

    List<HourlyForecast> result = [];
    for (int i = 0; i < times.length; i++) {
      final time = DateTime.parse(times[i]);
      if (time.isBefore(currentHour)) continue; // skip hours already passed

      result.add(
        HourlyForecast(
          time: DateTime.parse(times[i]),
          temperature: temps[i],
          weatherCode: WeatherCondition.fromCode(codes[i]),
        ),
      );
    }
    return result;
  }

  List<DailyForecast> _parseDailyForecast(Map<String, dynamic> json) {
    List dates = json['time'];
    List maxTemps = json['temperature_2m_max'];
    List minTemps = json['temperature_2m_min'];
    List codes = json['weather_code'];

    List<DailyForecast> result = [];
    for (int i = 0; i < dates.length; i++) {
      result.add(
        DailyForecast(
          date: DateTime.parse(dates[i]),
          tempMax: maxTemps[i],
          tempMin: minTemps[i],
          weatherCode: WeatherCondition.fromCode(codes[i]),
        ),
      );
    }
    return result;
  }
}

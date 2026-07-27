import 'current_weather.dart';
import 'hourly_forecast.dart';
import 'daily_forecast.dart';

class WeatherData {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
  });
}
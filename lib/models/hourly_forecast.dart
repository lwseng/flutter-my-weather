import 'current_weather.dart';

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final WeatherCondition weatherCode;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  String temperatureText(bool isCelsius) {
    final value = isCelsius ? temperature : (temperature * 9 / 5) + 32;
    final unit = isCelsius ? '°C' : '°F';
    return '${value.round()}$unit';
  }

  String get hourlyText {
    final now = DateTime.now();
    if (now.hour == time.hour && now.day == time.day) {
      return 'Now';
    }

    final hour = time.hour;
    final period = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour$period';
  }
}

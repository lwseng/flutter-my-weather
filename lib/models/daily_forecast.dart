import 'current_weather.dart';

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final WeatherCondition weatherCode;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  String temperatureMinText(bool isCelsius) {
    final value = isCelsius ? tempMin : (tempMin * 9 / 5) + 32;
    final unit = isCelsius ? '°C' : '°F';
    return '${value.round()}$unit';
  }

  String temperatureMaxText(bool isCelsius) {
    final value = isCelsius ? tempMax : (tempMax * 9 / 5) + 32;
    final unit = isCelsius ? '°C' : '°F';
    return '${value.round()}$unit';
  }

  String get dailyText {
    final now = DateTime.now();
    final weekday = date.weekday;
    if (now.day == date.day) {
      return 'Today';
    }
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}

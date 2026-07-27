import 'package:flutter/material.dart';

class CurrentWeather {
  final String time;
  final double temperature;
  final WeatherCondition weatherCode;
  final double windSpeed;
  final int humidity;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.humidity,
  });

  String temperatureText(bool isCelsius) {
    final value = isCelsius ? temperature : (temperature * 9 / 5) + 32;
    final unit = isCelsius ? '°C' : '°F';
    return '${value.round()}$unit';
  }
}

enum WeatherCondition {
  clear,
  partlyCloudy,
  foggy,
  drizzle,
  freezingDrizzle,
  rain,
  freezingRain,
  snow,
  snowGrains,
  rainShowers,
  snowShowers,
  thunderstorm,
  heavyThunderstorm,
  unknown;

  factory WeatherCondition.fromCode(int code) {
    switch (code) {
      case 0:
        return .clear;
      case 1 || 2 || 3:
        return .partlyCloudy;
      case 45 || 48:
        return .foggy;
      case 51 || 53 || 55:
        return .drizzle;
      case 56 || 57:
        return .freezingDrizzle;
      case 61 || 63 || 65:
        return .rain;
      case 66 || 67:
        return .freezingRain;
      case 71 || 73 || 75:
        return .snow;
      case 77:
        return .snowGrains;
      case 80 || 81 || 82:
        return .rainShowers;
      case 85 || 86:
        return .snowShowers;
      case 95:
        return .thunderstorm;
      case 96 || 99:
        return .heavyThunderstorm;
      default:
        return .unknown;
    }
  }

  String get description {
    switch (this) {
      case .clear:
        return 'Clear sky';
      case .partlyCloudy:
        return 'Mainly clear, partly cloudy, and overcast';
      case .foggy:
        return 'Fog and depositing rime fog';
      case .drizzle:
        return 'Drizzle: Light, moderate, and dense intensity';
      case .freezingDrizzle:
        return 'Freezing Drizzle: Light and dense intensity';
      case .rain:
        return 'Rain: Slight, moderate and heavy intensity';
      case .freezingRain:
        return 'Freezing Rain: Light and heavy intensity';
      case .snow:
        return 'Snow fall: Slight, moderate, and heavy intensity';
      case .snowGrains:
        return 'Snow grains';
      case .rainShowers:
        return 'Rain showers: Slight, moderate, and violent';
      case .snowShowers:
        return 'Snow showers slight and heavy';
      case .thunderstorm:
        return 'Thunderstorm: Slight or moderate';
      case .heavyThunderstorm:
        return 'Thunderstorm with slight and heavy hail';
      case .unknown:
        return 'Unable to get weather info';
    }
  }

  IconData get icon {
    switch (this) {
      case .clear:
        return Icons.wb_sunny;

      case .partlyCloudy:
        return Icons.wb_cloudy;

      case .foggy:
        return Icons.foggy;

      case .drizzle:
      case .freezingDrizzle:
      case .rain:
      case .freezingRain:
      case .rainShowers:
        return Icons.beach_access;

      case .snow:
      case .snowGrains:
      case .snowShowers:
        return Icons.ac_unit;

      case .thunderstorm:
      case .heavyThunderstorm:
        return Icons.thunderstorm;

      case .unknown:
        return Icons.help_outline;
    }
  }
}

import 'package:flutter/material.dart';

import '../../models/hourly_forecast.dart';

class HourlyForecastTile extends StatelessWidget {
  final HourlyForecast? hourly;
  final bool isCelsius;

  const HourlyForecastTile({
    required this.hourly,
    required this.isCelsius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Text(hourly?.hourlyText ?? ''),
        Icon(hourly?.weatherCode.icon, size: 30),
        Text(hourly?.temperatureText(isCelsius) ?? ''),
      ],
    );
  }
}

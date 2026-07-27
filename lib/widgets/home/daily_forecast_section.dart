import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'daily_forecast_tile.dart';
import '../../providers/weather_provider.dart';
import '../base/base_card.dart';
import '../../models/daily_forecast.dart';

class DailyForecastSection extends StatelessWidget {
  const DailyForecastSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyForecast = context.select<WeatherProvider, List<DailyForecast>?>(
      (provider) => provider.weatherData?.daily,
    );
    final isCelsius = context.select<WeatherProvider, bool>(
      (provider) => provider.isCelsius,
    );

    return BaseCard(
      titleText: '7-day forecast',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (index, daily) in (dailyForecast ?? []).indexed)
            DailyForecastTile(daily: daily, isCelsius: isCelsius, isLastTile: index == (dailyForecast?.length ?? 0) - 1),
        ],
      ),
    );
  }
}

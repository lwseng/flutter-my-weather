import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hourly_forecast_tile.dart';
import '../../providers/weather_provider.dart';
import '../base/base_card.dart';
import '../../models/hourly_forecast.dart';

class HourlyForecastSection extends StatelessWidget {
  const HourlyForecastSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hourlyForecast = context
        .select<WeatherProvider, List<HourlyForecast>?>(
          (provider) => provider.weatherData?.hourly,
        );
    final isCelsius = context.select<WeatherProvider, bool>(
      (provider) => provider.isCelsius,
    );

    return BaseCard(
      titleText: 'Hourly',
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(hourlyForecast?.length ?? 0, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SizedBox(
                width: 40,
                child: HourlyForecastTile(
                  hourly: hourlyForecast?[index],
                  isCelsius: isCelsius,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

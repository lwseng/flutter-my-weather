import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/current_weather.dart';
import '../../providers/weather_provider.dart';

class CurrentWeatherSection extends StatelessWidget {
  final bool isPreviewMode;
  const CurrentWeatherSection({this.isPreviewMode = false, super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = context.select<WeatherProvider, String>(
      (provider) => provider.locationName,
    );
    final locationInfo = context.select<WeatherProvider, String>(
      (provider) => provider.locationInfo,
    );
    final currentWeather = context.select<WeatherProvider, CurrentWeather?>(
      (provider) => provider.weatherData?.current,
    );
    final isCelsius = context.select<WeatherProvider, bool>(
      (provider) => provider.isCelsius,
    );

    return Column(
      spacing: 30,
      children: [
        if (!isPreviewMode)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLocation,
                      style: TextTheme.of(context).titleLarge,
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    Text(
                      locationInfo,
                      style: TextTheme.of(context).titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        Center(
          child: Column(
            spacing: 20,
            children: [
              Column(
                children: [
                  Text(
                    currentWeather?.temperatureText(isCelsius) ?? '',
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currentWeather?.weatherCode.description ?? '',
                    style: TextTheme.of(context).titleMedium,
                  ),
                ],
              ),
              if (!isPreviewMode)
                SegmentedButton(
                  style: SegmentedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), // small radius = near-square
                  ),
                  segments: [
                    const ButtonSegment(value: true, label: Text('C°')),
                    const ButtonSegment(value: false, label: Text('F°')),
                  ],
                  showSelectedIcon: false,
                  selected: {isCelsius},
                  onSelectionChanged: (_) =>
                      context.read<WeatherProvider>().toggleUnit(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

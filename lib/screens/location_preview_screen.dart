import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/base/base_content_view.dart';
import '../widgets/home/current_weather_section.dart';
import '../widgets/home/hourly_forecast_section.dart';
import '../widgets/home/daily_forecast_section.dart';

import '../providers/saved_locations_provider.dart';
import '../providers/weather_provider.dart';
import '../models/saved_location.dart';
import '../models/location_data.dart';

class LocationPreviewScreen extends StatelessWidget {
  final Location location;
  const LocationPreviewScreen({required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider()
        ..setInitialUnit(context.read<WeatherProvider>().isCelsius)
        ..fetchWeatherForSavedPosition(SavedLocation(location: location)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(location.name),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Builder(
              builder: (context) {
                final isSaved = context.select<SavedLocationsProvider, bool>(
                  (provider) => provider.isSaved(location.id),
                );
                if (isSaved) {
                  return Row(
                    children: const [
                      Icon(Icons.check, color: Colors.green, size: 16),
                      Text(
                        'Added',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                      SizedBox(width: 10),
                    ],
                  );
                } else {
                  return IconButton(
                    onPressed: () => context
                        .read<SavedLocationsProvider>()
                        .addLocation(SavedLocation(location: location)),
                    icon: const Icon(Icons.add),
                  );
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              final isLoading = context.select<WeatherProvider, bool>(
                (p) => p.isLoading,
              );
              final errorMessage = context.select<WeatherProvider, String?>(
                (p) => p.errorMessage,
              );
              return BaseContentView(
                isLoading: isLoading,
                errorMessage: errorMessage,
                content: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 20,
                    children: [
                      CurrentWeatherSection(isPreviewMode: true),
                      HourlyForecastSection(),
                      DailyForecastSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

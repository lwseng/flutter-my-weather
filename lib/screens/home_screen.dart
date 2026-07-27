import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/base/base_content_view.dart';
import '../widgets/home/current_weather_section.dart';
import '../widgets/home/hourly_forecast_section.dart';
import '../widgets/home/daily_forecast_section.dart';
import '../providers/weather_provider.dart';
import '../providers/saved_locations_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;

      final savedLocations = context
          .read<SavedLocationsProvider>()
          .savedLocations;

      final currentLocation = await context
          .read<WeatherProvider>()
          .restoreLastSelection(savedLocations);

      if (!mounted) return;

      if (currentLocation != null) {
        context.read<SavedLocationsProvider>().addLocation(currentLocation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<WeatherProvider, bool>(
      (provider) => provider.isLoading,
    );
    final errorMessage = context.select<WeatherProvider, String?>(
      (provider) => provider.errorMessage,
    );

    return Scaffold(
      body: SafeArea(
        child: BaseContentView(
          isLoading: isLoading,
          errorMessage: errorMessage,
          onRetry: () =>
              context.read<WeatherProvider>().fetchWeatherForCurrentPosition(),
          content: const Padding(
            padding: .all(10.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  CurrentWeatherSection(),
                  HourlyForecastSection(),
                  DailyForecastSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

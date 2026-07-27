import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/screens/home_screen.dart';
import '/screens/main_tab_screen.dart';
import '/screens/saved_screen.dart';
import '/screens/search_screen.dart';
import 'providers/weather_provider.dart';
import 'providers/saved_locations_provider.dart';

import 'constants/route_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedLocationProviders = SavedLocationsProvider();
  await savedLocationProviders.loadSavedLocations();

  final weatherProvider = WeatherProvider();
  await weatherProvider.loadUnitPreference();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: weatherProvider),
        ChangeNotifierProvider.value(value: savedLocationProviders),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.indigoAccent),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: RouteConstants.mainTabScreenName,
      routes: {
        RouteConstants.mainTabScreenName: (context) => const MainTabScreen(),
        RouteConstants.homeScreenName: (context) => const HomeScreen(),
        RouteConstants.searchScreenName: (context) => const SearchScreen(),
        RouteConstants.savedScreenName: (context) => const SavedScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../presentation/camera_screen/camera_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/records_screen/records_screen.dart';
import '../presentation/prediction_results_screen/prediction_results_screen.dart';

class AppRoutes {
  // Route names
  static const String initial = '/'; // App starts here
  static const String camera = '/camera-screen';
  static const String settings = '/settings-screen';
  static const String home = '/home-screen';
  static const String records = '/records-screen';
  static const String predictionResults = '/prediction-results-screen';

  // Map routes to their respective screens
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),  // <-- HomeScreen launches first
    camera: (context) => const CameraScreen(),
    settings: (context) => const SettingsScreen(),
    home: (context) => const HomeScreen(),
    records: (context) => const RecordsScreen(),
    predictionResults: (context) => const PredictionResultsScreen(),
    // Add any additional routes here
  };
}

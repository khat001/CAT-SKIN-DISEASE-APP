import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _predictionsKey = 'saved_predictions';

  static Future<void> savePrediction({
    required String predictedClass,
    required double confidence,
    required String imagePath,
    required List<dynamic> allPredictions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final prediction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'predicted_class': predictedClass,
      'confidence': confidence,
      'image_path': imagePath,
      'all_predictions': allPredictions,
      'timestamp': DateTime.now().toIso8601String(),
    };

    List<String> savedPredictions = prefs.getStringList(_predictionsKey) ?? [];
    savedPredictions.insert(0, jsonEncode(prediction));
    
    // Keep only last 50 predictions
    if (savedPredictions.length > 50) {
      savedPredictions = savedPredictions.take(50).toList();
    }
    
    await prefs.setStringList(_predictionsKey, savedPredictions);
  }

  static Future<List<Map<String, dynamic>>> getSavedPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedPredictions = prefs.getStringList(_predictionsKey) ?? [];
    
    return savedPredictions.map((prediction) {
      return Map<String, dynamic>.from(jsonDecode(prediction));
    }).toList();
  }

  static Future<void> deletePrediction(String predictionId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedPredictions = prefs.getStringList(_predictionsKey) ?? [];
    
    savedPredictions.removeWhere((prediction) {
      final decoded = jsonDecode(prediction);
      return decoded['id'] == predictionId;
    });
    
    await prefs.setStringList(_predictionsKey, savedPredictions);
  }

  static Future<void> clearAllPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_predictionsKey);
  }
}

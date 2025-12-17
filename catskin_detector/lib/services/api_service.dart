import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  static const String baseUrl = 'https://katty0169-meowskin-backend.hf.space';

  Future<Map<String, dynamic>> predictImage(File imageFile) async {
    print('=== PREDICTION START ===');
    print('File path: ${imageFile.path}');
    
    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }
      
      print('File exists, size: ${await imageFile.length()} bytes');
      
      // Create request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.20.10.9:5000/predict'),
      );
      
      print('Created multipart request');
      
      // Read file bytes and create multipart file
      var bytes = await imageFile.readAsBytes();
      print('Read ${bytes.length} bytes from file');
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: 'image.jpg',
        ),
      );
      
      print('Added file to request, sending...');
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      print('Got response: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        
        // Convert all_probabilities Map to List format expected by UI
        List<Map<String, dynamic>> allPredictions = [];
        if (result['all_probabilities'] != null) {
          final probabilities = result['all_probabilities'] as Map<String, dynamic>;
          allPredictions = probabilities.entries
              .map((entry) => {
                    'class': entry.key,
                    'confidence': entry.value,
                  })
              .toList();
          // Sort by confidence descending
          allPredictions.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));
        }
        
        return {
          'success': result['success'],
          'predicted_class': result['predicted_class'],
          'confidence': result['confidence'],
          'all_predictions': allPredictions,
        };
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('PREDICTION ERROR: $e');
      rethrow;
    }
  }


}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

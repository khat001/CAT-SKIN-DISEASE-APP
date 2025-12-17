import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/expandable_info_section_widget.dart';
import './widgets/image_preview_widget.dart';
import './widgets/medical_disclaimer_widget.dart';
import './widgets/prediction_card_widget.dart';


class PredictionResultsScreen extends StatefulWidget {
  const PredictionResultsScreen({Key? key}) : super(key: key);

  @override
  State<PredictionResultsScreen> createState() =>
      _PredictionResultsScreenState();
}

class _PredictionResultsScreenState extends State<PredictionResultsScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? predictionData;
  bool isLoading = true;
  String? error;
  File? imageFile;
  bool isSavedRecord = false;

  void _takeAnotherPhoto() {
    Navigator.pop(context);
  }

  void _saveToRecords() async {
    if (predictionData == null || imageFile == null) return;
    
    try {
      await StorageService.savePrediction(
        predictedClass: predictionData!['predicted_class'],
        confidence: predictionData!['confidence'],
        imagePath: imageFile!.path,
        allPredictions: predictionData!['all_predictions'],
      );
      
      Fluttertoast.showToast(
        msg: "Results saved to records successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        textColor: Colors.white,
      );
      
      // Wait 1 second then navigate to homepage
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-screen',
        (route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save results",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  String _formatPredictionForSharing() {
    if (predictionData == null) return '';
    return '''
Condition: ${predictionData!["predicted_class"]}
Confidence: ${(predictionData!["confidence"] * 100).toStringAsFixed(1)}%
Analyzed: ${DateTime.now().toString().split('.')[0]}
    ''';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading && imageFile == null) {
      _loadPredictionData();
    }
  }

  void _loadPredictionData() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('Prediction args: $args');
    
    if (args != null && args['imageFile'] != null) {
      imageFile = args['imageFile'] as File;
      print('Image file path: ${imageFile!.path}');
      
      // Check if this is a saved record with existing prediction data
      if (args['predictionData'] != null) {
        setState(() {
          predictionData = args['predictionData'] as Map<String, dynamic>;
          isLoading = false;
          isSavedRecord = true;
        });
        print('Loaded saved prediction: ${predictionData!['predicted_class']}');
      } else {
        // Make new prediction and auto-save
        await _makePrediction();
      }
    } else {
      setState(() {
        error = 'No image provided';
        isLoading = false;
      });
    }
  }

  Future<void> _makePrediction() async {
    print('=== _makePrediction called ===');
    print('Image file: ${imageFile?.path}');
    print('Image file exists: ${imageFile?.existsSync()}');
    
    try {
      print('Calling _apiService.predictImage...');
      final result = await _apiService.predictImage(imageFile!);
      print('API returned: $result');
      
      if (result['success'] == true) {
        setState(() {
          predictionData = result;
          isLoading = false;
        });
        print('Prediction successful: ${result['predicted_class']}');
      } else {
        setState(() {
          error = result['error'] ?? 'Prediction failed';
          isLoading = false;
        });
        print('Prediction failed: ${result['error']}');
      }
    } catch (e) {
      print('Exception in _makePrediction: $e');
      setState(() {
        error = 'Server connection failed: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Analysis Results'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/records-screen'),
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text(error!, textAlign: TextAlign.center),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Go Back'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image preview
                            if (imageFile != null)
                              Container(
                                width: double.infinity,
                                height: 250,
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                            // Prediction results
                            if (predictionData != null)
                              PredictionCardWidget(
                                predictedClass: predictionData!['predicted_class'],
                                confidence: predictionData!['confidence'],
                                allPredictions: predictionData!['all_predictions'],
                              ),

                            // Medical disclaimer
                            const MedicalDisclaimerWidget(),

                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ),

                    // Bottom action buttons (only show for new predictions, not saved records)
                    if (!isSavedRecord)
                      ActionButtonsWidget(
                        onTakeAnotherPhoto: _takeAnotherPhoto,
                        onSaveToRecords: _saveToRecords,
                        predictionData: _formatPredictionForSharing(),
                      ),
                  ],
                ),
    );
  }
}

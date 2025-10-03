import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/expandable_info_section_widget.dart';
import './widgets/image_preview_widget.dart';
import './widgets/medical_disclaimer_widget.dart';


class PredictionResultsScreen extends StatefulWidget {
  const PredictionResultsScreen({Key? key}) : super(key: key);

  @override
  State<PredictionResultsScreen> createState() =>
      _PredictionResultsScreenState();
}

class _PredictionResultsScreenState extends State<PredictionResultsScreen> {
  // DITO YUNG PREDICTION DATA NA DAPAT MULA SA MODEL/ REMOVED PLACEHOLDERS/MOCK DATA
  final Map<String, dynamic> predictionData = {};

  void _takeAnotherPhoto() {
    Navigator.pushReplacementNamed(context, '/camera-screen');
  }

  void _saveToRecords() {
    // Simulate saving to records
    Fluttertoast.showToast(
      msg: "Results saved to records successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
    );
  }

  String _formatPredictionForSharing() {
    return '''
Condition: ${predictionData["condition"]}
Confidence: ${(predictionData["confidence"] as double).toStringAsFixed(1)}%
Severity: ${predictionData["severity"]}
Analyzed: ${predictionData["timestamp"].toString().split('.')[0]}
    ''';
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image preview with timestamp
                  ImagePreviewWidget(
                    imageUrl: predictionData["imageUrl"] as String,
                    timestamp: predictionData["timestamp"] as DateTime,
                  ),

                  //A. PASTE
         
                  // Expandable information sections
                  ExpandableInfoSectionWidget(
                    title: 'About This Condition',
                    content: predictionData["about"] as String,
                    iconName: 'info',
                  ),

                  ExpandableInfoSectionWidget(
                    title: 'Recommended Actions',
                    content: predictionData["recommendations"] as String,
                    iconName: 'healing',
                  ),

                  ExpandableInfoSectionWidget(
                    title: 'When to See Vet',
                    content: predictionData["vetConsultation"] as String,
                    iconName: 'local_hospital',
                  ),

                  // Medical disclaimer
                  const MedicalDisclaimerWidget(),

                  // Bottom padding for action buttons
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),

          // Bottom action buttons
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

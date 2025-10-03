import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_capture_button_widget.dart';
import './widgets/medical_disclaimer_widget.dart';
import './widgets/quick_access_shortcuts_widget.dart';
import './widgets/recent_predictions_widget.dart';
import './widgets/welcome_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final ImagePicker _imagePicker = ImagePicker();

  // DATA FOR RECENT PREDICTIONS! DITO DATI YUNG MOCK RECULTS OR PLACEHOLDER
  final List<Map<String, dynamic>> _recentPredictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Welcome Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: const WelcomeHeaderWidget(),
                ),

                SizedBox(height: 3.h),

                // Camera Capture Button
                CameraCaptureButtonWidget(
                  onPressed: _navigateToCamera,
                  onGalleryPressed: _pickFromGallery,
                ),

                SizedBox(height: 2.h),

                // Medical Disclaimer
                const MedicalDisclaimerWidget(),

                SizedBox(height: 3.h),

                // Recent Predictions
                RecentPredictionsWidget(
                  predictions: _recentPredictions.take(5).toList(),
                  onViewAllPressed: _navigateToRecords,
                  onPredictionTap: _navigateToPredictionDetails,
                ),

                SizedBox(height: 3.h),

                // Quick Access Shortcuts
                QuickAccessShortcutsWidget(
                  onRecordsPressed: _navigateToRecords,
                  onSettingsPressed: _navigateToSettings,
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      currentIndex: 0,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Records',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Settings',
        ),
      ],
      onTap: _onBottomNavTap,
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch latest predictions from database
    setState(() {
      // Update timestamps to show refresh worked
      for (var prediction in _recentPredictions) {
        if (prediction['id'] == 1) {
          prediction['timestamp'] = DateTime.now().subtract(
            const Duration(minutes: 30),
          );
        }
      }
    });
  }

  void _navigateToCamera() {
    Navigator.pushNamed(context, '/camera-screen');
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        // Process the selected image similar to camera
        _processGalleryImage(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image from gallery');
    }
  }

  Future<void> _processGalleryImage(String imagePath) async {
    // Generate mock prediction results for gallery image
    final Map<String, dynamic> mockResult = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "imagePath": imagePath,
      "predictions": [
        {
          "disease": "Feline Acne",
          "accuracy": 87.5,
          "description":
              "Feline acne is a common skin condition affecting the chin and lip area of cats.",
          "causes": [
            "Stress and poor grooming habits",
            "Plastic food bowls",
            "Hormonal changes",
            "Poor hygiene",
          ],
          "remedies": [
            "Clean affected area with warm water",
            "Use stainless steel or ceramic bowls",
            "Apply topical treatments as prescribed",
            "Maintain good hygiene",
          ],
        },
        {
          "disease": "Ringworm",
          "accuracy": 12.3,
          "description":
              "A fungal infection that affects the skin, hair, and nails.",
          "causes": [
            "Contact with infected animals",
            "Contaminated environment",
            "Weakened immune system",
          ],
          "remedies": [
            "Antifungal medications",
            "Topical treatments",
            "Environmental decontamination",
          ],
        },
      ],
      "timestamp": DateTime.now(),
      "disclaimer":
          "This analysis is for early detection purposes only and should not replace professional veterinary diagnosis. Please consult a veterinarian for proper medical advice.",
    };

    // Navigate to prediction results
    Navigator.pushNamed(
      context,
      '/prediction-results-screen',
      arguments: mockResult,
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _navigateToRecords() {
    Navigator.pushNamed(context, '/records-screen');
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings-screen');
  }

  void _navigateToPredictionDetails(Map<String, dynamic> prediction) {
    Navigator.pushNamed(
      context,
      '/prediction-results-screen',
      arguments: prediction,
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Already on home screen
        break;
      case 1:
        _navigateToCamera();
        break;
      case 2:
        _navigateToRecords();
        break;
      case 3:
        _navigateToSettings();
        break;
    }
  }
}

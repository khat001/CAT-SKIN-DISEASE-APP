import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/storage_service.dart';
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

  // Recent predictions loaded from storage
  List<Map<String, dynamic>> _recentPredictions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentPredictions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh predictions when returning to home screen
    _loadRecentPredictions();
  }

  Future<void> _loadRecentPredictions() async {
    try {
      final predictions = await StorageService.getSavedPredictions();
      setState(() {
        _recentPredictions = predictions.take(5).map((prediction) => {
          'condition': prediction['predicted_class'],
          'confidence': prediction['confidence'],
          'timestamp': DateTime.parse(prediction['timestamp']),
          'imageUrl': prediction['image_path'],
          'id': prediction['id'],
          'all_predictions': prediction['all_predictions'],
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _recentPredictions = [];
        _isLoading = false;
      });
    }
  }

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
                _isLoading
                    ? Container(
                        height: 20.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      )
                    : RecentPredictionsWidget(
                        predictions: _recentPredictions,
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
    await _loadRecentPredictions();
  }

  void _navigateToCamera() {
    Navigator.pushNamed(context, '/camera-screen').then((_) => _loadRecentPredictions());
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
    // Navigate to prediction results with image file
    Navigator.pushNamed(
      context,
      '/prediction-results-screen',
      arguments: {
        'imageFile': File(imagePath),
      },
    ).then((_) => _loadRecentPredictions());
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
    Navigator.pushNamed(context, '/records-screen').then((_) => _loadRecentPredictions());
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings-screen');
  }

  void _navigateToPredictionDetails(Map<String, dynamic> prediction) {
    Navigator.pushNamed(
      context,
      '/prediction-results-screen',
      arguments: {
        'imageFile': File(prediction['imageUrl']),
        'predictionData': {
          'success': true,
          'predicted_class': prediction['condition'],
          'confidence': prediction['confidence'],
          'all_predictions': prediction['all_predictions'] ?? [],
        },
      },
    ).then((_) => _loadRecentPredictions()); // Refresh when returning
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

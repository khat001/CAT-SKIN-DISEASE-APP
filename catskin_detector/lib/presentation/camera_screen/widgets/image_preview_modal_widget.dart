
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePreviewModalWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;
  final bool isProcessing;

  const ImagePreviewModalWidget({
    Key? key,
    required this.imagePath,
    required this.onRetake,
    required this.onConfirm,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textSecondaryLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preview Image',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                if (!isProcessing)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimaryLight,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),

          // Image preview
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? CustomImageWidget(
                        imageUrl: imagePath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : CustomImageWidget(
                        imageUrl: 'file://$imagePath',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          // Processing indicator
          if (isProcessing)
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.primaryLight,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Analyzing image...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

          // Action buttons
          if (!isProcessing)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRetake,
                      child: Text('Retake'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      child: Text('Analyze'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

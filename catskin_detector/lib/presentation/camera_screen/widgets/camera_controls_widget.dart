import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final VoidCallback? onFlipCamera;
  final bool isCapturing;
  final bool showFlipButton;

  const CameraControlsWidget({
    Key? key,
    required this.onCapture,
    required this.onGallery,
    this.onFlipCamera,
    required this.isCapturing,
    required this.showFlipButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 15.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gallery button
            GestureDetector(
              onTap: onGallery,
              child: Container(
                width: 15.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // Capture button
            GestureDetector(
              onTap: isCapturing ? null : onCapture,
              child: Container(
                width: 20.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: isCapturing
                      ? AppTheme.textSecondaryLight
                      : AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: isCapturing
                    ? Center(
                        child: SizedBox(
                          width: 6.w,
                          height: 3.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 32,
                      ),
              ),
            ),

            // Flip camera button
            showFlipButton
                ? GestureDetector(
                    onTap: onFlipCamera,
                    child: Container(
                      width: 15.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'flip_camera_ios',
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  )
                : SizedBox(width: 15.w),
          ],
        ),
      ),
    );
  }
}

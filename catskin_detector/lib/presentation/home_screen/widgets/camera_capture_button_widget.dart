import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraCaptureButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback? onGalleryPressed;

  const CameraCaptureButtonWidget({
    Key? key,
    required this.onPressed,
    this.onGalleryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onGalleryPressed != null) {
      return _buildDualActionWidget(context);
    } else {
      return _buildSingleActionWidget(context);
    }
  }

  Widget _buildDualActionWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // Camera Button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'camera_alt',
                    color: Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Camera',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Gallery Button
          Expanded(
            child: ElevatedButton(
              onPressed: onGalleryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.lightTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 2,
                  ),
                ),
                elevation: 2,
              ),
              child: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleActionWidget(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _buildIOSButton(context);
    } else {
      return _buildAndroidButton(context);
    }
  }

  Widget _buildIOSButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Analyze Cat\'s Skin',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: Colors.white,
          size: 6.w,
        ),
        label: Text(
          'Analyze Cat\'s Skin',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

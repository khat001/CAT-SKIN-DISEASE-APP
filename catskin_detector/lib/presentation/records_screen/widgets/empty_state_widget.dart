import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onTakeFirstPhoto;

  const EmptyStateWidget({
    Key? key,
    required this.onTakeFirstPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration Container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withOpacity( 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Title
            Text(
              'No Predictions Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextColor(context),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Description
            Text(
              'Start monitoring your cat\'s skin health by taking your first photo. All your predictions will appear here for easy tracking.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getTextColor(context, isSecondary: true),
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Call-to-Action Button
            ElevatedButton.icon(
              onPressed: onTakeFirstPhoto,
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text(
                'Take First Photo',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Secondary Action
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home-screen');
              },
              child: Text(
                'Learn More About Skin Conditions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

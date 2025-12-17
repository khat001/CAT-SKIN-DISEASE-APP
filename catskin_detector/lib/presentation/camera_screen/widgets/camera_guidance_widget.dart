import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraGuidanceWidget extends StatelessWidget {
  final String currentTip;

  const CameraGuidanceWidget({
    Key? key,
    required this.currentTip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.primaryLight,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(150),
            ),
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryLight.withOpacity( 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity( 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentTip,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

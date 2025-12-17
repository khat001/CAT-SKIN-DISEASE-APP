import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalDisclaimerWidget extends StatelessWidget {
  const MedicalDisclaimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withOpacity( 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withOpacity( 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Medical Disclaimer',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'This application is designed for educational purposes and early detection assistance only. The AI analysis results should not be considered as a professional veterinary diagnosis.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Always consult with a qualified veterinarian for proper diagnosis and treatment of your cat\'s health conditions.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

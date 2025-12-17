import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalDisclaimerWidget extends StatelessWidget {
  const MedicalDisclaimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withOpacity( 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.warningLight.withOpacity( 0.3),
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
                color: AppTheme.warningLight,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Medical Disclaimer',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warningLight,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'This application is designed for early detection and educational purposes only. It is NOT a substitute for professional veterinary diagnosis or treatment.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Always consult with a qualified veterinarian for proper diagnosis and treatment of your pet\'s health conditions.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextColor(context, isSecondary: true),
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

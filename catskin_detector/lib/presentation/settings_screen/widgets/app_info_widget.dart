import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppInfoWidget extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const AppInfoWidget({
    Key? key,
    required this.appVersion,
    required this.buildNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity( 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withOpacity( 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 12.w,
                height: 12.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'MeowSkin',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your Furr-iendly Cat App',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextColor(context, isSecondary: true),
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Version $appVersion',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextColor(context, isSecondary: true),
                    ),
              ),
              Text(
                ' ($buildNumber)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextColor(context, isSecondary: true),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StorageInfoWidget extends StatelessWidget {
  final String usedSpace;
  final String totalSpace;
  final double usagePercentage;

  const StorageInfoWidget({
    Key? key,
    required this.usedSpace,
    required this.totalSpace,
    required this.usagePercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withOpacity( 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity( 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Storage Used',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '$usedSpace / $totalSpace',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getTextColor(context, isSecondary: true),
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usagePercentage / 100,
              backgroundColor:
                  Theme.of(context).colorScheme.outline.withOpacity( 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                usagePercentage > 80
                    ? AppTheme.errorLight
                    : usagePercentage > 60
                        ? AppTheme.warningLight
                        : Theme.of(context).colorScheme.primary,
              ),
              minHeight: 1.h,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '${usagePercentage.toStringAsFixed(1)}% used',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextColor(context, isSecondary: true),
                ),
          ),
        ],
      ),
    );
  }
}

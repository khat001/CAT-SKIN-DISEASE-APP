import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentPredictionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> predictions;
  final VoidCallback onViewAllPressed;
  final Function(Map<String, dynamic>) onPredictionTap;

  const RecentPredictionsWidget({
    Key? key,
    required this.predictions,
    required this.onViewAllPressed,
    required this.onPredictionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Predictions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onViewAllPressed,
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          predictions.isEmpty ? _buildEmptyState() : _buildPredictionsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity( 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withOpacity( 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CustomIconWidget(
              iconName: 'photo_camera',
              color: AppTheme.lightTheme.primaryColor,
              size: 12.w,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Predictions Yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Take your first photo to start monitoring your cat\'s skin health',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsList() {
    return SizedBox(
      height: 24.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          return _buildPredictionCard(prediction);
        },
      ),
    );
  }

  Widget _buildPredictionCard(Map<String, dynamic> prediction) {
    final condition = prediction['condition'] as String? ?? 'Unknown';
    final confidence = prediction['confidence'] as double? ?? 0.0;
    final timestamp = prediction['timestamp'] as DateTime? ?? DateTime.now();
    final imageUrl = prediction['imageUrl'] as String? ?? '';

    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPredictionTap(prediction),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withOpacity( 0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? Image.file(
                              File(imageUrl),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: CustomIconWidget(
                                  iconName: 'pets',
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                  size: 8.w,
                                ),
                              ),
                            )
                          : Center(
                              child: CustomIconWidget(
                                iconName: 'pets',
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                size: 8.w,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 0.5.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        condition,
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.3.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.w),
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(confidence).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(confidence * 100).toStringAsFixed(1)}%',
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getConfidenceColor(confidence),
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.3.w),
                      Text(
                        _formatTimestamp(timestamp),
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppTheme.successLight;
    if (confidence >= 0.6) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

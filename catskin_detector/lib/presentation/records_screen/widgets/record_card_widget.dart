import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecordCardWidget extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RecordCardWidget({
    Key? key,
    required this.record,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: Key(record['id'].toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context);
      },
      onDismissed: (direction) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 6.w,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Thumbnail Image
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.lightTheme.colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: record['imagePath'] != null && File(record['imagePath']).existsSync()
                        ? Image.file(
                            File(record['imagePath']),
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 15.w,
                            height: 15.w,
                            color: Colors.grey.shade300,
                            child: Icon(
                              Icons.image,
                              color: Colors.grey.shade600,
                              size: 6.w,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Record Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Condition Name
                      Text(
                        record['condition'] ?? 'Unknown Condition',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getTextColor(context),
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),

                      // Confidence Percentage
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(record['confidence'] ?? 0)
                              .withOpacity( 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${record['confidence']?.toStringAsFixed(1) ?? '0.0'}% confidence',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getConfidenceColor(
                                        record['confidence'] ?? 0),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // Date and Preview
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme.getTextColor(context,
                                isSecondary: true),
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              _formatDate(record['date']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.getTextColor(context,
                                        isSecondary: true),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.getTextColor(context, isSecondary: true),
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) {
      return AppTheme.successLight;
    } else if (confidence >= 60) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'Invalid date';
      }

      return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Record',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this prediction record? This action cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSortOption;
  final Function(String) onSortChanged;

  const SortOptionsWidget({
    Key? key,
    required this.currentSortOption,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSortChanged,
      icon: CustomIconWidget(
        iconName: 'sort',
        color: AppTheme.getTextColor(context),
        size: 6.w,
      ),
      itemBuilder: (BuildContext context) => [
        _buildPopupMenuItem(
          value: 'newest_first',
          title: 'Newest First',
          icon: 'arrow_downward',
          isSelected: currentSortOption == 'newest_first',
        ),
        _buildPopupMenuItem(
          value: 'oldest_first',
          title: 'Oldest First',
          icon: 'arrow_upward',
          isSelected: currentSortOption == 'oldest_first',
        ),
        _buildPopupMenuItem(
          value: 'condition_type',
          title: 'Condition Type',
          icon: 'category',
          isSelected: currentSortOption == 'condition_type',
        ),
        _buildPopupMenuItem(
          value: 'confidence_high',
          title: 'Confidence (High to Low)',
          icon: 'trending_down',
          isSelected: currentSortOption == 'confidence_high',
        ),
        _buildPopupMenuItem(
          value: 'confidence_low',
          title: 'Confidence (Low to High)',
          icon: 'trending_up',
          isSelected: currentSortOption == 'confidence_low',
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required String title,
    required String icon,
    required bool isSelected,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.textPrimaryLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (isSelected)
            CustomIconWidget(
              iconName: 'check',
              color: AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
        ],
      ),
    );
  }
}

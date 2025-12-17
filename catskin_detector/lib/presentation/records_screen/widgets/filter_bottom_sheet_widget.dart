import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _selectedDateRange = _filters['dateRange'] as DateTimeRange?;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.getTextColor(context, isSecondary: true),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Records',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: Text('Clear All'),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Date Range Filter
          _buildFilterSection(
            title: 'Date Range',
            child: InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'date_range',
                      color: AppTheme.getTextColor(context, isSecondary: true),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        _selectedDateRange != null
                            ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                            : 'Select date range',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _selectedDateRange != null
                                  ? AppTheme.getTextColor(context)
                                  : AppTheme.getTextColor(context,
                                      isSecondary: true),
                            ),
                      ),
                    ),
                    if (_selectedDateRange != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDateRange = null;
                            _filters['dateRange'] = null;
                          });
                        },
                        child: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.getTextColor(context, isSecondary: true),
                          size: 4.w,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Condition Type Filter
          _buildFilterSection(
            title: 'Condition Type',
            child: Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildConditionChip('All', null),
                _buildConditionChip('Feline Acne', 'feline_acne'),
                _buildConditionChip('Ringworm', 'ringworm'),
                _buildConditionChip('Mange', 'mange'),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Confidence Level Filter
          _buildFilterSection(
            title: 'Confidence Level',
            child: Column(
              children: [
                _buildConfidenceChip('All Levels', null),
                _buildConfidenceChip('High (80%+)', 'high'),
                _buildConfidenceChip('Medium (60-79%)', 'medium'),
                _buildConfidenceChip('Low (<60%)', 'low'),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }

  Widget _buildConditionChip(String label, String? value) {
    final isSelected = _filters['conditionType'] == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filters['conditionType'] = selected ? value : null;
        });
      },
      selectedColor: AppTheme.lightTheme.primaryColor.withOpacity( 0.2),
      checkmarkColor: AppTheme.lightTheme.primaryColor,
    );
  }

  Widget _buildConfidenceChip(String label, String? value) {
    final isSelected = _filters['confidenceLevel'] == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filters['confidenceLevel'] = selected ? value : null;
        });
      },
      selectedColor: AppTheme.lightTheme.primaryColor.withOpacity( 0.2),
      checkmarkColor: AppTheme.lightTheme.primaryColor,
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filters['dateRange'] = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/storage_service.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/record_card_widget.dart';
import './widgets/sort_options_widget.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allRecords = [];
  List<Map<String, dynamic>> _filteredRecords = [];
  Map<String, dynamic> _activeFilters = {};
  String _currentSortOption = 'newest_first';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSavedRecords();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSavedRecords() async {
    final savedPredictions = await StorageService.getSavedPredictions();
    
    _allRecords = savedPredictions.map((prediction) {
      return {
        'id': int.parse(prediction['id']),
        'condition': prediction['predicted_class'],
        'confidence': (prediction['confidence'] * 100).toDouble(),
        'date': DateTime.parse(prediction['timestamp']),
        'imagePath': prediction['image_path'],
        'severity': _getSeverityFromConfidence(prediction['confidence']),
        'location': 'Unknown',
        'all_predictions': prediction['all_predictions'],
      };
    }).toList();

    _applyFiltersAndSort();
  }
  
  String _getSeverityFromConfidence(double confidence) {
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.6) return 'Medium';
    return 'Low';
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allRecords);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((record) {
        final condition = (record['condition'] as String? ?? '').toLowerCase();
        final location = (record['location'] as String? ?? '').toLowerCase();
        final severity = (record['severity'] as String? ?? '').toLowerCase();

        return condition.contains(searchTerm) ||
            location.contains(searchTerm) ||
            severity.contains(searchTerm);
      }).toList();
    }

    // Apply date range filter
    if (_activeFilters['dateRange'] != null) {
      final DateTimeRange dateRange =
          _activeFilters['dateRange'] as DateTimeRange;
      filtered = filtered.where((record) {
        final recordDate = record['date'] as DateTime?;
        if (recordDate == null) return false;

        return recordDate
                .isAfter(dateRange.start.subtract(Duration(days: 1))) &&
            recordDate.isBefore(dateRange.end.add(Duration(days: 1)));
      }).toList();
    }

    // Apply condition type filter
    if (_activeFilters['conditionType'] != null) {
      final conditionType = _activeFilters['conditionType'] as String;
      filtered = filtered.where((record) {
        final condition = (record['condition'] as String? ?? '').toLowerCase();
        return condition.replaceAll(' ', '_').toLowerCase() == conditionType;
      }).toList();
    }

    // Apply confidence level filter
    if (_activeFilters['confidenceLevel'] != null) {
      final confidenceLevel = _activeFilters['confidenceLevel'] as String;
      filtered = filtered.where((record) {
        final confidence = record['confidence'] as double? ?? 0.0;
        switch (confidenceLevel) {
          case 'high':
            return confidence >= 80;
          case 'medium':
            return confidence >= 60 && confidence < 80;
          case 'low':
            return confidence < 60;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    switch (_currentSortOption) {
      case 'newest_first':
        filtered.sort((a, b) {
          final dateA = a['date'] as DateTime? ?? DateTime(1970);
          final dateB = b['date'] as DateTime? ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });
        break;
      case 'oldest_first':
        filtered.sort((a, b) {
          final dateA = a['date'] as DateTime? ?? DateTime(1970);
          final dateB = b['date'] as DateTime? ?? DateTime(1970);
          return dateA.compareTo(dateB);
        });
        break;
      case 'condition_type':
        filtered.sort((a, b) {
          final conditionA = a['condition'] as String? ?? '';
          final conditionB = b['condition'] as String? ?? '';
          return conditionA.compareTo(conditionB);
        });
        break;
      case 'confidence_high':
        filtered.sort((a, b) {
          final confidenceA = a['confidence'] as double? ?? 0.0;
          final confidenceB = b['confidence'] as double? ?? 0.0;
          return confidenceB.compareTo(confidenceA);
        });
        break;
      case 'confidence_low':
        filtered.sort((a, b) {
          final confidenceA = a['confidence'] as double? ?? 0.0;
          final confidenceB = b['confidence'] as double? ?? 0.0;
          return confidenceA.compareTo(confidenceB);
        });
        break;
    }

    setState(() {
      _filteredRecords = filtered;
    });
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _applyFiltersAndSort();
  }

  void _onSortChanged(String sortOption) {
    setState(() {
      _currentSortOption = sortOption;
    });
    _applyFiltersAndSort();
  }

  void _deleteRecord(int recordId) async {
    try {
      await StorageService.deletePrediction(recordId.toString());
      
      setState(() {
        _allRecords.removeWhere((record) => record['id'] == recordId);
      });
      _applyFiltersAndSort();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Record deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete record'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshRecords() async {
    await Future.delayed(Duration(seconds: 1));
    _loadSavedRecords();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _navigateToRecordDetails(Map<String, dynamic> record) {
    // Convert record format to match what prediction results screen expects
    final predictionData = {
      'success': true,
      'predicted_class': record['condition'],
      'confidence': record['confidence'] / 100, // Convert back to 0-1 range
      'all_predictions': record['all_predictions'],
    };
    
    Navigator.pushNamed(
      context,
      '/prediction-results-screen',
      arguments: {
        'imageFile': File(record['imagePath']),
        'predictionData': predictionData,
      },
    );
  }

  void _navigateToCamera() {
    Navigator.pushNamed(context, '/camera-screen');
  }

  int get _activeFilterCount {
    int count = 0;
    if (_activeFilters['dateRange'] != null) count++;
    if (_activeFilters['conditionType'] != null) count++;
    if (_activeFilters['confidenceLevel'] != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Records',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          SortOptionsWidget(
            currentSortOption: _currentSortOption,
            onSortChanged: _onSortChanged,
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Section
            Container(
              padding: EdgeInsets.all(4.w),
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.getSurfaceColor(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isSearching
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: _isSearching ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search records...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: AppTheme.getTextColor(context,
                                  isSecondary: true),
                              size: 5.w,
                            ),
                          ),
                          suffixIcon: _isSearching
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: CustomIconWidget(
                                      iconName: 'clear',
                                      color: AppTheme.getTextColor(context,
                                          isSecondary: true),
                                      size: 5.w,
                                    ),
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Filter Button
                  Container(
                    decoration: BoxDecoration(
                      color: _activeFilterCount > 0
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.getSurfaceColor(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _activeFilterCount > 0
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: _showFilterBottomSheet,
                          icon: CustomIconWidget(
                            iconName: 'filter_list',
                            color: _activeFilterCount > 0
                                ? Colors.white
                                : AppTheme.getTextColor(context),
                            size: 6.w,
                          ),
                        ),
                        if (_activeFilterCount > 0)
                          Positioned(
                            right: 1.w,
                            top: 1.w,
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppTheme.errorLight,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 4.w,
                                minHeight: 4.w,
                              ),
                              child: Text(
                                _activeFilterCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Records List
            Expanded(
              child: _filteredRecords.isEmpty
                  ? EmptyStateWidget(
                      onTakeFirstPhoto: _navigateToCamera,
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshRecords,
                      color: AppTheme.lightTheme.primaryColor,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _filteredRecords.length,
                        itemBuilder: (context, index) {
                          final record = _filteredRecords[index];
                          return RecordCardWidget(
                            record: record,
                            onTap: () => _navigateToRecordDetails(record),
                            onDelete: () => _deleteRecord(record['id'] as int),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Records tab is active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-screen');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/camera-screen');
              break;
            case 2:
              // Already on Records screen
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/settings-screen');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.getTextColor(context, isSecondary: true),
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.getTextColor(context, isSecondary: true),
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.getTextColor(context, isSecondary: true),
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.getTextColor(context, isSecondary: true),
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FocusIndicatorWidget extends StatefulWidget {
  final Offset? focusPoint;
  final bool isVisible;

  const FocusIndicatorWidget({
    Key? key,
    this.focusPoint,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<FocusIndicatorWidget> createState() => _FocusIndicatorWidgetState();
}

class _FocusIndicatorWidgetState extends State<FocusIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(FocusIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.focusPoint == null) {
      return SizedBox.shrink();
    }

    return Positioned(
      left: widget.focusPoint!.dx - 8.w,
      top: widget.focusPoint!.dy - 4.h,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 16.w,
              height: 8.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Container(
                  width: 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onFlashToggle;
  final bool isFlashOn;
  final bool showFlash;

  const CameraOverlayWidget({
    Key? key,
    required this.onClose,
    required this.onFlashToggle,
    required this.isFlashOn,
    required this.showFlash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            if (showFlash)
              GestureDetector(
                onTap: onFlashToggle,
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: isFlashOn ? 'flash_on' : 'flash_off',
                    color: isFlashOn ? AppTheme.warningLight : Colors.white,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_guidance_widget.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/focus_indicator_widget.dart';
import './widgets/image_preview_modal_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isCapturing = false;
  bool _isProcessing = false;
  String? _capturedImagePath;
  Offset? _focusPoint;
  bool _showFocusIndicator = false;

  final ImagePicker _imagePicker = ImagePicker();

  // Guidance tips
  final List<String> _guidanceTips = [
    'Hold steady',
    'Ensure good lighting',
    'Focus on affected area',
    'Keep camera still',
    'Move closer if needed',
  ];

  int _currentTipIndex = 0;
  late AnimationController _tipAnimationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _setupTipAnimation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _tipAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  void _setupTipAnimation() {
    _tipAnimationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _tipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _guidanceTips.length;
        });
        _tipAnimationController.reset();
        _tipAnimationController.forward();
      }
    });

    _tipAnimationController.forward();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        _showPermissionDialog();
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showErrorDialog('No cameras available on this device');
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      // Silently handle unsupported features
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      // Flash not supported
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;

    final currentLensDirection = _cameraController!.description.lensDirection;
    final newCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection != currentLensDirection,
      orElse: () => _cameras.first,
    );

    await _cameraController!.dispose();

    _cameraController = CameraController(
      newCamera,
      kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _applySettings();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      HapticFeedback.lightImpact();
      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImagePath = photo.path;
        _isCapturing = false;
      });

      _showImagePreview();
    } catch (e) {
      setState(() {
        _isCapturing = false;
      });
      _showErrorDialog('Failed to capture photo: ${e.toString()}');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        // Navigate directly to prediction results with gallery image
        Navigator.pushNamed(
          context,
          '/prediction-results-screen',
          arguments: {
            'imageFile': File(image.path),
          },
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image from gallery');
    }
  }

  void _onTapToFocus(TapDownDetails details) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      _focusPoint = tapPosition;
      _showFocusIndicator = true;
    });

    HapticFeedback.selectionClick();

    // Hide focus indicator after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showFocusIndicator = false;
        });
      }
    });

    // Set focus point for camera
    try {
      final double x = tapPosition.dx / renderBox.size.width;
      final double y = tapPosition.dy / renderBox.size.height;
      _cameraController!.setFocusPoint(Offset(x, y));
      _cameraController!.setExposurePoint(Offset(x, y));
    } catch (e) {
      // Focus/exposure not supported
    }
  }

  void _showImagePreview() {
    if (_capturedImagePath == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ImagePreviewModalWidget(
        imagePath: _capturedImagePath!,
        isProcessing: _isProcessing,
        onRetake: () {
          Navigator.pop(context);
          setState(() {
            _capturedImagePath = null;
          });
        },
        onConfirm: () {
          Navigator.pop(context);
          _processImage();
        },
      ),
    );
  }

  Future<void> _processImage() async {
    if (_capturedImagePath == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Show processing modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ImagePreviewModalWidget(
        imagePath: _capturedImagePath!,
        isProcessing: true,
        onRetake: () {},
        onConfirm: () {},
      ),
    );

    try {
      Navigator.pop(context); // Close processing modal

      // Navigate to prediction results with image file
      Navigator.pushNamed(
        context,
        '/prediction-results-screen',
        arguments: {
          'imageFile': File(_capturedImagePath!),
        },
      );
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog('Failed to process image. Please try again.');
      setState(() {
        _isProcessing = false;
        _capturedImagePath = null;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text(
            'This app needs camera access to capture images for skin condition analysis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized ? _buildCameraView() : _buildLoadingView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryLight,
          ),
          SizedBox(height: 4.h),
          Text(
            'Initializing camera...',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: GestureDetector(
            onTapDown: _onTapToFocus,
            child: CameraPreview(_cameraController!),
          ),
        ),

        // Top overlay with controls
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CameraOverlayWidget(
            onClose: () => Navigator.pop(context),
            onFlashToggle: _toggleFlash,
            isFlashOn: _isFlashOn,
            showFlash: !kIsWeb,
          ),
        ),

        // Camera guidance overlay
        CameraGuidanceWidget(
          currentTip: _guidanceTips[_currentTipIndex],
        ),

        // Focus indicator
        FocusIndicatorWidget(
          focusPoint: _focusPoint,
          isVisible: _showFocusIndicator,
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CameraControlsWidget(
            onCapture: _capturePhoto,
            onGallery: _pickFromGallery,
            onFlipCamera: _cameras.length > 1 ? _flipCamera : null,
            isCapturing: _isCapturing,
            showFlipButton: _cameras.length > 1,
          ),
        ),
      ],
    );
  }
}

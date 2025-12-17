import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_info_widget.dart';
import './widgets/medical_disclaimer_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings
  bool _predictionAlerts = true;
  bool _healthReminders = false;

  // Mock data for storage and app info
  final Map<String, dynamic> _mockData = {
    "appInfo": {
      "version": "1.2.3",
      "buildNumber": "2025.10.01",
      "developer": "Khatrina B. Angeles",
      "lastUpdate": "October 1, 2025",
    },
    "veterinaryBoard": [
      {
        "name": "Dr. Crizelle Indunan",
        "title": "Liscensed Veterinarian",
        "institution": "UPLB Veterinary Teaching Hospital"
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    final appInfo = _mockData["appInfo"] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Notifications Section
              SettingsSectionWidget(
                title: 'NOTIFICATIONS',
                children: [
                  SettingsItemWidget(
                    title: 'Prediction Alerts',
                    subtitle: 'Get notified when analysis is complete',
                    iconName: 'notifications',
                    trailing: Switch(
                      value: _predictionAlerts,
                      onChanged: (bool value) {
                        setState(() {
                          _predictionAlerts = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    title: 'Health Reminders',
                    subtitle: 'Periodic reminders for pet health checkups',
                    iconName: 'schedule',
                    trailing: Switch(
                      value: _healthReminders,
                      onChanged: (bool value) {
                        setState(() {
                          _healthReminders = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Privacy & Data Section
              SettingsSectionWidget(
                title: 'PRIVACY & DATA',
                children: [
                  SettingsItemWidget(
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    iconName: 'privacy_tip',
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                  SettingsItemWidget(
                    title: 'Data Usage',
                    subtitle: 'All data stored locally on your device',
                    iconName: 'security',
                    onTap: () => _showDataUsageInfo(context),
                  ),
                ],
              ),

              // About Section
              SettingsSectionWidget(
                title: 'ABOUT',
                children: [
                  AppInfoWidget(
                    appVersion: appInfo["version"] as String,
                    buildNumber: appInfo["buildNumber"] as String,
                  ),
                  SettingsItemWidget(
                    title: 'Developer Information',
                    subtitle: appInfo["developer"] as String,
                    iconName: 'code',
                    onTap: () => _showDeveloperInfo(context),
                  ),
                  SettingsItemWidget(
                    title: 'Veterinary Advisory Board',
                    subtitle: 'Meet our expert veterinarians',
                    iconName: 'medical_services',
                    onTap: () => _showVeterinaryBoard(context),
                  ),
                  SettingsItemWidget(
                    title: 'Medical Disclaimer',
                    subtitle: 'Important health information',
                    iconName: 'warning',
                    iconColor: AppTheme.warningLight,
                    onTap: () => _showMedicalDisclaimer(context),
                  ),
                ],
              ),

              // Help & Support Section
              SettingsSectionWidget(
                title: 'HELP & SUPPORT',
                children: [
                  SettingsItemWidget(
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    iconName: 'help',
                    onTap: () => _showFAQ(context),
                  ),
                ],
              ),

              // Medical Disclaimer Widget
              MedicalDisclaimerWidget(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) => _onBottomNavTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.getTextColor(context, isSecondary: true),
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.primary,
              size: 6.w,
            ),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: Theme.of(context).colorScheme.primary,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'settings',
              color: Theme.of(context).colorScheme.primary,
              size: 6.w,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/camera-screen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/records-screen');
        break;
      case 3:
        // Already on settings screen
        break;
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: Text(
              'MeowSkin Privacy Policy\n\n'
              '• All images and predictions are stored locally on your device\n'
              '• No personal data is transmitted to external servers\n'
              '• AI processing may use cloud services with encrypted data\n'
              '• You can delete all data at any time through the app\n'
              '• We do not collect personal information\n'
              '• Camera access is only used for taking photos\n\n'
              'For complete privacy policy, visit our website.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDataUsageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Usage Information'),
          content: Text(
            'Data Storage:\n'
            '• Photos: Stored locally in app directory\n'
            '• Predictions: Saved in local database\n'
            '• Settings: Stored in device preferences\n\n'
            'Network Usage:\n'
            '• AI processing may require internet\n'
            '• No automatic data uploads\n'
            '• All data remains on your device',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void _showDeveloperInfo(BuildContext context) {
    final appInfo = _mockData["appInfo"] as Map<String, dynamic>;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Developer Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Developer: ${appInfo["developer"]}'),
              SizedBox(height: 1.h),
              Text('Version: ${appInfo["version"]}'),
              SizedBox(height: 1.h),
              Text('Build: ${appInfo["buildNumber"]}'),
              SizedBox(height: 1.h),
              Text('Last Update: ${appInfo["lastUpdate"]}'),
              SizedBox(height: 2.h),
              Text(
                'Specialized in AI-powered veterinary diagnostic tools for early detection of feline health conditions.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showVeterinaryBoard(BuildContext context) {
    final veterinaryBoard = _mockData["veterinaryBoard"] as List<dynamic>;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veterinary Advisory Board'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: veterinaryBoard.map<Widget>((vet) {
                final vetData = vet as Map<String, dynamic>;
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vetData["name"] as String,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        vetData["title"] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        vetData["institution"] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.getTextColor(context,
                                  isSecondary: true),
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showMedicalDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.warningLight,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text('Medical Disclaimer'),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              'IMPORTANT MEDICAL DISCLAIMER\n\n'
              'This application is designed for educational and early detection purposes only. It is NOT intended to replace professional veterinary diagnosis, treatment, or advice.\n\n'
              'Key Points:\n'
              '• This app provides preliminary assessments only\n'
              '• Results should not be considered definitive diagnoses\n'
              '• Always consult a qualified veterinarian for proper medical evaluation\n'
              '• Do not delay professional veterinary care based on app results\n'
              '• Emergency conditions require immediate veterinary attention\n\n'
              'The developers and veterinary advisors are not responsible for any decisions made based solely on this application\'s output.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('I Understand'),
            ),
          ],
        );
      },
    );
  }

  void _showFAQ(BuildContext context) {
    final List<Map<String, String>> faqData = [
      {
        "question": "How accurate is the AI detection?",
        "answer":
            "Our AI model has been trained on thousands of feline skin condition images with veterinary validation. However, it's designed for early detection and should not replace professional diagnosis."
      },
      {
        "question": "Can I use this app for other pets?",
        "answer":
            "This app is specifically designed and trained for feline (cat) skin conditions. Using it for other animals may not provide accurate results."
      },
      {
        "question": "How should I take photos for best results?",
        "answer":
            "Ensure good lighting, hold the camera steady, and capture the affected area clearly. The app will guide you through the photo-taking process."
      },
      {
        "question": "Is my data secure?",
        "answer":
            "Yes, all photos and predictions are stored locally on your device. No personal data is transmitted to external servers without your consent."
      },
      {
        "question": "What should I do if the app detects a problem?",
        "answer":
            "Contact your veterinarian immediately for proper diagnosis and treatment. The app is for early detection only and cannot replace professional veterinary care."
      }
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Frequently Asked Questions'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: faqData.length,
              itemBuilder: (context, index) {
                final faq = faqData[index];
                return ExpansionTile(
                  title: Text(
                    faq["question"]!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Text(
                        faq["answer"]!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

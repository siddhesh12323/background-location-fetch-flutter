import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:services/screens/home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request Notification Permission first
    PermissionStatus notificationStatus =
        await Permission.notification.request();

    if (notificationStatus.isDenied) {
      _showPermissionDeniedDialog("Notification Permission is required.");
      return; // Stop further execution if denied
    }

    // If notification permission is granted, request Location Permission
    PermissionStatus locationStatus = await Permission.location.request();

    if (locationStatus.isDenied) {
      _showPermissionDeniedDialog("Location Permission is required.");
      return;
    }

    // If location permission is granted, request Location Always Permission
    PermissionStatus locationAlwaysStatus =
        await Permission.locationAlways.request();

    if (locationAlwaysStatus.isGranted) {
      _navigateToHomePage();
    } else {
      _showPermissionDeniedDialog("Location Permission is required.");
      return;
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showPermissionDeniedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Checking Permissions...")),
    );
  }
}

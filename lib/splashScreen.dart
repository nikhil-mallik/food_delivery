import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/login.dart';
import 'dashboard.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus(); // Check the user status when the splash screen is loaded
  }

  // Function to check the user status (if they have a username and role in SharedPreferences)
  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if both username and userRole are stored in SharedPreferences
    String? username = prefs.getString('username');
    String? userRole = prefs.getString('userRole');

    // If both are present, navigate to the Dashboard screen
    if (username != null && userRole != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()), // Navigate to Dashboard
      );
    } else {
      // If username or userRole is missing, navigate to Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()), // Navigate to Login
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading indicator while checking the user status
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading spinner while checking
      ),
    );
  }
}

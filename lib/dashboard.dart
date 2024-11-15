import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Admin/home_admin.dart';
import 'Pages/home.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Fetch user role when the screen is initialized
  }

  // Fetch the user role from SharedPreferences
  Future<void> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole'); // Get the stored user role

    setState(() {
      userRole = role; // Update the userRole state
    });

    // Once the user role is retrieved, navigate based on role
    if (role != null) {
      _navigateToRoleBasedScreen(role);
    }
  }

  // Navigate to the appropriate screen based on the user's role
  void _navigateToRoleBasedScreen(String role) {
    if (role == 'Admin') {
      // Navigate to Admin Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeAdmin()),
      );
    } else {
      // If the role is unknown, navigate to a default page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wait for userRole to be fetched
    if (userRole == null) {
      return const Center(child: CircularProgressIndicator()); // Show loading until role is fetched
    }

    // You can also navigate based on the role here or display role-specific content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Text('Current Role: $userRole'), // Display the current role for now
      ),
    );
  }
}

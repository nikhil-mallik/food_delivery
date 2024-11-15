import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore

import '../dashboard.dart';
import '../wiget/widget_support.dart';
import 'forgotpassword.dart';

import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for the TextFields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Method for logging in
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Sign in the user with email and password
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful login, fetch user details from Firestore
      String username = await getUsername(userCredential.user!);
      String userRole = await getUserRole(userCredential.user!);

      // Store the user details in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);  // Store name
      await prefs.setString('userRole', userRole);  // Store role

      // Successful login, navigate to the Home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      String errorMsg;
      if (e.code == 'user-not-found') {
        errorMsg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Wrong password provided for that user.";
      } else {
        errorMsg = "Login failed: ${e.message}";
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMsg, style: const TextStyle(fontSize: 20)),
        backgroundColor: Colors.redAccent,
      ));
    } catch (e) {
      // Catch any other errors
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An unexpected error occurred.",
            style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  // Fetch username from Firestore
  Future<String> getUsername(User user) async {
    try {
      // Get user document from Firestore using user UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')  // 'users' collection
          .doc(user.uid)  // Use user UID as document ID
          .get();

      // Check if the document exists and fetch the 'name' field
      if (userDoc.exists) {
        return userDoc['name'] ?? 'Default Name';  // Use 'name' field from Firestore
      } else {
        return 'Default Name';  // Return a default value if user data is not found
      }
    } catch (e) {
      return 'Default Name';  // Return default if any error occurs
    }
  }

  // Fetch role from Firestore
  Future<String> getUserRole(User user) async {
    try {
      // Get user document from Firestore using user UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')  // 'users' collection
          .doc(user.uid)  // Use user UID as document ID
          .get();

      // Check if the document exists and fetch the 'role' field
      if (userDoc.exists) {
        return userDoc['role'] ?? 'user';  // Use 'role' field from Firestore
      } else {
        return 'user';  // Default role if no user data is found
      }
    } catch (e) {
      return 'user';  // Default role if any error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFff5c30),
                    Color(0xFFe74b1a),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: const Text(""),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/logo.png",
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30.0),
                          Text("Login",
                              style: AppWidget.HeadlineTextFeildStyle()),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: AppWidget.semiboldTextFeildStyle(),
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: AppWidget.semiboldTextFeildStyle(),
                              prefixIcon: const Icon(Icons.password_outlined),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const Forgotpassword(),
                                  ));
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Text("Forgot Password?ss",
                                  style: AppWidget.semiboldTextFeildStyle()),
                            ),
                          ),
                          const SizedBox(height: 80.0),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(20),
                            child: GestureDetector(
                              onTap: login, // Call the login method on tap
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xffff5722),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins1',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 70.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ));
                    },
                    child: Text("Don't have an account? Sign up",
                        style: AppWidget.semiboldTextFeildStyle()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

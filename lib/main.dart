import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



import 'Admin/Category/addCategory.dart';

import 'Admin/Category/fetchCategory.dart';
import 'Admin/food/add_food.dart';
import 'Admin/food/fetchFood.dart';
import 'Admin/home_admin.dart';
import 'Pages/home.dart';
import 'firebase_options.dart';
import 'splashScreen.dart';

// ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: AddCategoryPage(),
        // home: FetchCategoryPage(),
        // home: AddFood(),
        // home: FetchFood(),
        // home: HomeAdmin(),
        // home: Home(),
        home: Splashscreen(),
    );
  }
}
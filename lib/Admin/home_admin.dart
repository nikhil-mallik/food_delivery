import 'package:flutter/material.dart';


import '../wiget/widget_support.dart';
import 'Category/addCategory.dart';
import 'Category/fetchCategory.dart';
import 'food/add_food.dart';
import 'food/fetchFood.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Home Admin",
                style: AppWidget.HeadlineTextFeildStyle(),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            // Card 1: Add Food Items
            buildCard(
              context,
              "assets/food.jpg",
              "Add Food Items",
              const AddFood(),
            ),
            const SizedBox(height: 20.0),

            // Card 2: Manage Orders
            buildCard(
              context,
              "assets/food.jpg",
              "Fetch Orders",
              const FetchFood(), // Replace with the appropriate screen
            ),
            const SizedBox(height: 20.0),

            // Card 3: View Reports
            buildCard(
              context,
              "assets/food.jpg",
              "Add Category",
              const AddCategoryPage(), // Replace with the appropriate screen
            ),
            const SizedBox(height: 20.0),

            // Card 4: User Feedback
            buildCard(
              context,
              "assets/food.jpg",
              "Fetch Category",
              FetchCategoryPage(), // Replace with the appropriate screen
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Reusable Card Widget
  Widget buildCard(BuildContext context, String imagePath, String title, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    imagePath,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 30.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

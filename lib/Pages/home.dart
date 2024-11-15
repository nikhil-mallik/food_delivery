import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../wiget/widget_support.dart'; // Make sure the import is correct
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCategory = ''; // Track the selected category

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch categories from Firestore
  Future<List<String>> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Categories').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  // Fetch items from Firestore and filter based on the selected category
  Future<List<Map<String, dynamic>>> _fetchItems(String category) async {
    try {
      QuerySnapshot snapshot;

      // If no category is selected, fetch all items
      if (category.isEmpty) {
        snapshot = await _firestore.collection('Items').get();
      } else {
        snapshot = await _firestore
            .collection('Items')
            .where('CategoryName',
                isEqualTo:
                    category) // Assuming 'category' is a field in your 'Items' collection
            .get();
      }

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Make the entire screen scrollable
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Niraj", style: AppWidget.boldTextFeildStyle()),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text("Delicious Food", style: AppWidget.HeadlineTextFeildStyle()),
              Text("Delicious and Get Great Food",
                  style: AppWidget.LightTextFeildStyle()),
              const SizedBox(height: 20.0),

              // Category selection (Ice Cream, Pizza, etc.)
              FutureBuilder<List<String>>(
                future: _fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  } else {
                    List<String> categories = snapshot.data!;
                    return showItem(categories);
                  }
                },
              ),
              const SizedBox(height: 20.0),

              // Fetching data from Firestore and displaying using FutureBuilder
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchItems(selectedCategory),
                // Fetch items based on selected category
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No items found'));
                  } else {
                    List<Map<String, dynamic>> items = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      // To make it not take full height
                      physics: const NeverScrollableScrollPhysics(),
                      // Disable scrolling for GridView
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        return _buildCard(item);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a card widget for each item
  Widget _buildCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(
              imageUrl: item['Image'],  // Pass the image URL
              name: item['Name'],       // Pass the item name
              description: item['Detail'],  // Pass the item description
              price: item['Price'].toString(),  // Pass the item price
            ),
          ),
        );
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 200, // Set fixed height for the card
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: item['Image'].isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item['Image'],
                          fit: BoxFit.cover,
                          height: 70,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey),
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(height: 10),

                // Item Name
                Text(
                  _trimTitle(item['Name']),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1, // Limit the description to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Show ellipsis if it's longer
                ),

                const SizedBox(height: 5),

                // Description with trimming to 30 words
                Text(
                  _trimDescription(item['Detail']),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 2, // Limit the description to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Show ellipsis if it's longer
                ),
                const SizedBox(height: 10),

                // Price
                Text("\$${item['Price']}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to trim the title to 15 words
  String _trimTitle(String title) {
    List<String> words = title.split(' '); // Split the title into words
    if (words.length > 15) {
      words = words.take(15).toList(); // Take only the first 15 words
      return '${words.join(' ')}...'; // Join the words and append "..."
    }
    return title; // Return as is if it's already less than 15 words
  }

  // Function to trim the description to 30 words
  String _trimDescription(String description) {
    List<String> words =
        description.split(' '); // Split the description into words
    if (words.length > 30) {
      words = words.take(30).toList(); // Take only the first 30 words
      return '${words.join(' ')}...'; // Join the words and append "..."
    }
    return description; // Return as is if it's already less than 30 words
  }

  // Category filter buttons (Ice Cream, Pizza, etc.)
  Widget showItem(List<String> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return _buildCategoryButton(category);
      }).toList(),
    );
  }

  // Helper method to build category selection buttons with icons
  Widget _buildCategoryButton(String name) {
    IconData icon;
    switch (name) {
      case 'Ice Cream':
        icon = Icons.icecream; // Use the default Flutter icon for Ice Cream
        break;
      case 'Pizza':
        icon = Icons.local_pizza; // Use the default Flutter icon for Pizza
        break;
      case 'Salad':
        icon = Icons.local_dining; // Use the default Flutter icon for Salad
        break;
      case 'Burger':
        icon = Icons.fastfood; // Use the default Flutter icon for Burger
        break;
      default:
        icon = Icons.category; // Default icon if unknown
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = (selectedCategory == name)
              ? ''
              : name; // Toggle the selected category
        });
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: selectedCategory == name ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 40,
            color: selectedCategory == name ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

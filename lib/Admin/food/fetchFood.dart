import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFood extends StatefulWidget {
  const FetchFood({super.key});

  @override
  State<FetchFood> createState() => _FetchFoodState();
}

class _FetchFoodState extends State<FetchFood> {
  // Function to fetch order data from Firestore (real-time updates)
  Stream<QuerySnapshot> fetchOrders() {
    return FirebaseFirestore.instance.collection('Items').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items List"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchOrders(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching orders"),
            );
          }

          // Show loading indicator while data is being fetched
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Check if there are any orders
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No orders found"),
            );
          }

          // Retrieve order documents
          final orders = snapshot.data!.docs;

          // Display order items in a ListView
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              // Extract order data
              var orderData = orders[index].data() as Map<String, dynamic>;

              // Get individual fields
              String imageUrl = orderData['Image'] ?? '';
              String name = orderData['Name'] ?? 'No Name';
              String price = orderData['Price'] ?? '0';
              String detail = orderData['Detail'] ?? 'No Details';
              String categoryName =
                  orderData['CategoryName'] ?? 'Unknown Category';

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  // contentPadding: const EdgeInsets.all(10.0),
                  leading: SizedBox(
                  width: 80,
                  height: double.infinity, // This ensures the image height matches the card height
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    )
                        : const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),

                title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: \$${price}"),
                      Text("Category: $categoryName"),
                      const SizedBox(height: 5.0),
                      Text(
                        detail,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

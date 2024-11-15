// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:random_string/random_string.dart';
//
// import '../DataBase/users_detail.dart';
// import '../wiget/widget_support.dart';
//
// class AddFood extends StatefulWidget {
//   const AddFood({super.key});
//
//   @override
//   State<AddFood> createState() => _AddFoodState();
// }
//
// class _AddFoodState extends State<AddFood> {
//   final List<String> fooditems = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
//   String? value; // Dropdown value
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController pricecontroller = TextEditingController();
//   TextEditingController detailcontroller = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   File? selectedImage;
//
//   // Function to pick an image
//   Future<void> getImage() async {
//     try {
//       var image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           selectedImage = File(image.path);
//         });
//       } else {
//         _showSnackBar("No image selected", Colors.redAccent);
//       }
//     } catch (e) {
//       _showSnackBar("Error selecting image: $e", Colors.redAccent);
//     }
//   }
//
//   // Function to upload the item details
//   Future<void> uploadItem() async {
//     if (selectedImage != null &&
//         namecontroller.text.isNotEmpty &&
//         pricecontroller.text.isNotEmpty &&
//         detailcontroller.text.isNotEmpty &&
//         value != null) {
//       try {
//         String addId = randomAlphaNumeric(10);
//         Reference firebaseStorageRef =
//             FirebaseStorage.instance.ref().child("blogImages").child(addId);
//         final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
//
//         var downloadUrl = await (await task).ref.getDownloadURL();
//
//         Map<String, dynamic> addItem = {
//           "Image": downloadUrl,
//           "Name": namecontroller.text,
//           "Price": pricecontroller.text,
//           "Detail": detailcontroller.text,
//           "category": value
//         };
//
//         await DatabaseMethods().addFoodItem(addItem).then(() {
//           _showSnackBar(
//             "Food Item has been added successfully",
//             Colors.orangeAccent,
//           );
//         });
//       } catch (e) {
//         _showSnackBar("Error uploading item: $e", Colors.redAccent);
//       }
//     } else {
//       _showSnackBar(
//           "Please fill all the fields and select an image", Colors.redAccent);
//     }
//   }
//
//   // Function to show a SnackBar message
//   void _showSnackBar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: backgroundColor,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child:
//               const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF373866)),
//         ),
//         centerTitle: true,
//         title: Text("Add Item", style: AppWidget.HeadlineTextFeildStyle()),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Upload the Item Picture",
//                   style: AppWidget.semiboldTextFeildStyle()),
//               const SizedBox(height: 20.0),
//               selectedImage == null
//                   ? GestureDetector(
//                       onTap: getImage,
//                       child: Center(
//                         child: Material(
//                           elevation: 4.0,
//                           borderRadius: BorderRadius.circular(20),
//                           child: Container(
//                             width: 150,
//                             height: 150,
//                             decoration: BoxDecoration(
//                               border:
//                                   Border.all(color: Colors.black, width: 1.5),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: const Icon(Icons.camera_alt_outlined,
//                                 color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     )
//                   : Center(
//                       child: Material(
//                         elevation: 4.0,
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           width: 150,
//                           height: 150,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black, width: 1.5),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: Image.file(
//                               selectedImage!,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//               const SizedBox(height: 30.0),
//               Text("Item Name", style: AppWidget.semiboldTextFeildStyle()),
//               const SizedBox(height: 10.0),
//               _buildTextField(namecontroller, "Enter Item Name"),
//               const SizedBox(height: 30.0),
//               Text("Item Price", style: AppWidget.semiboldTextFeildStyle()),
//               const SizedBox(height: 10.0),
//               _buildTextField(pricecontroller, "Enter Item Price"),
//               const SizedBox(height: 30.0),
//               Text("Item Detail", style: AppWidget.semiboldTextFeildStyle()),
//               const SizedBox(height: 10.0),
//               _buildTextField(detailcontroller, "Enter Item Detail",
//                   maxLines: 6),
//               const SizedBox(height: 20.0),
//               Text("Select category",
//                   style: AppWidget.semiboldTextFeildStyle()),
//               const SizedBox(height: 20.0),
//               _buildDropdown(),
//               const SizedBox(height: 30.0),
//               GestureDetector(
//                 onTap: uploadItem,
//                 child: Center(
//                   child: Material(
//                     elevation: 5.0,
//                     borderRadius: BorderRadius.circular(10),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 5.0),
//                       width: 150,
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Add",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build TextFields
//   Widget _buildTextField(TextEditingController controller, String hint,
//       {int maxLines = 1}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFececf8),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: hint,
//           hintStyle: AppWidget.LightTextFeildStyle(),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build Dropdown
//   Widget _buildDropdown() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFececf8),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           items: fooditems
//               .map((item) => DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(item,
//                         style: const TextStyle(fontSize: 18.0, color: Colors.black)),
//                   ))
//               .toList(),
//           onChanged: (newValue) {
//             setState(() {
//               value = newValue;
//             });
//           },
//           dropdownColor: Colors.white,
//           hint: const Text("Select category"),
//           iconSize: 36,
//           icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
//           value: value,
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../wiget/widget_support.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String? selectedCategoryId;
  String? selectedCategoryName;
  List<Map<String, String>> categories = []; // List to hold category data
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      // Fetching categories from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Categories').get();
      List<Map<String, String>> loadedCategories = [];

      // Loop through categories and add them to the list
      snapshot.docs.forEach((doc) {
        loadedCategories.add({
          'id': doc.id,
          'name': doc['name'],
        });
      });

      setState(() {
        categories = loadedCategories;
      });
    } catch (e) {
      _showSnackBar("Error fetching categories: $e", Colors.redAccent);
    }
  }

  // Function to pick an image
  Future<void> getImage() async {
    try {
      var image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      } else {
        _showSnackBar("No image selected", Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar("Error selecting image: $e", Colors.redAccent);
    }
  }

  void clearAllField() {
    namecontroller.clear();
    pricecontroller.clear();
    detailcontroller.clear();
  }

  // Function to upload the item details
// Function to upload the item details to the "Orders" collection
  Future<void> uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text.isNotEmpty &&
        pricecontroller.text.isNotEmpty &&
        detailcontroller.text.isNotEmpty &&
        selectedCategoryId != null) {
      try {
        String addId = randomAlphaNumeric(10);

        // Construct Firebase Storage path with category name
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("foodImages")
            .child(selectedCategoryName!) // Use category name as folder name
            .child('$addId.jpg'); // Save the image with a unique ID

        // Upload the image to Firebase Storage
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

        // Get the download URL after upload completes
        var downloadUrl = await (await task).ref.getDownloadURL();

        // Create a map for the item data
        Map<String, dynamic> orderItem = {
          "Image": downloadUrl, // Image URL
          "Name": namecontroller.text,
          "Price": pricecontroller.text,
          "Detail": detailcontroller.text,
          "CategoryId": selectedCategoryId,
          "CategoryName": selectedCategoryName,
          "OrderId": addId, // Unique Order ID
          "Timestamp": FieldValue.serverTimestamp(), // Order timestamp
        };

        // Add the item data to the "Orders" collection in Firestore
        await FirebaseFirestore.instance
            .collection('Items')
            .doc(addId)
            .set(orderItem);

        if (context.mounted) {
          Navigator.pop(context); // Close loader
        }

        clearAllField();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Items added successfully')),
        );
      } catch (e) {
        _showSnackBar("Error uploading item: $e", Colors.redAccent);
      }
    } else {
      _showSnackBar(
          "Please fill all the fields and select an image", Colors.redAccent);
    }
  }

  // Function to show a SnackBar message
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child:
        //   const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF373866)),
        // ),
        centerTitle: true,
        title: Text("Add Item", style: AppWidget.HeadlineTextFeildStyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload the Item Picture",
                  style: AppWidget.semiboldTextFeildStyle()),
              const SizedBox(height: 20.0),
              selectedImage == null
                  ? GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 30.0),
              Text("Select category",
                  style: AppWidget.semiboldTextFeildStyle()),
              const SizedBox(height: 20.0),
              _buildDropdown(),
              const SizedBox(height: 20.0),
              Text("Item Name", style: AppWidget.semiboldTextFeildStyle()),
              const SizedBox(height: 10.0),
              _buildTextField(namecontroller, "Enter Item Name"),
              const SizedBox(height: 30.0),
              Text("Item Price", style: AppWidget.semiboldTextFeildStyle()),
              const SizedBox(height: 10.0),
              _buildTextField(pricecontroller, "Enter Item Price"),
              const SizedBox(height: 30.0),
              Text("Item Detail", style: AppWidget.semiboldTextFeildStyle()),
              const SizedBox(height: 10.0),
              _buildTextField(detailcontroller, "Enter Item Detail",
                  maxLines: 6),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: uploadItem,
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
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
    );
  }

  // Helper method to build TextFields
  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppWidget.LightTextFeildStyle(),
        ),
      ),
    );
  }

  // Helper method to build Dropdown
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: categories
              .map((category) => DropdownMenuItem<String>(
                    value: category['id'],
                    child: Text(category['name']!,
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.black)),
                  ))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCategoryId = newValue;
              selectedCategoryName =
                  categories.firstWhere((cat) => cat['id'] == newValue)['name'];
            });
          },
          dropdownColor: Colors.white,
          hint: const Text("Select category"),
          iconSize: 36,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          value: selectedCategoryId,
        ),
      ),
    );
  }
}

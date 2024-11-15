import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  File? _image;
  final TextEditingController _categoryController = TextEditingController();
  bool _isButtonEnabled = false;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Function to upload image to Firebase Storage and save data to Firestore
  Future<void> _uploadCategory() async {
    if (_image != null && _categoryController.text.isNotEmpty) {
      // Generate a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      try {
        // Show loading indicator
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Upload image to Firebase Storage
        await _storage.ref('Categories/$fileName').putFile(_image!);
        String imageUrl = await _storage.ref('Categories/$fileName').getDownloadURL();

        // Create a new document and get its ID
        DocumentReference docRef = _firestore.collection('Categories').doc();
        String docId = docRef.id;

        // Save category data in Firestore, including the document ID
        await docRef.set({
          'id': docId, // Save the document ID
          'name': _categoryController.text,
          'image_url': imageUrl,
        });

        // Close the loading indicator
        if (context.mounted) {
          Navigator.pop(context); // Close loader
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('category added successfully')),
        );

        // Clear inputs
        _categoryController.clear();
        setState(() {
          _image = null;
        });

        // Navigate back to the previous screen
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        // Close the loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload category')),
        );
      }
    }
  }



  // Enable or disable the add button based on image and text input
  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _image != null && _categoryController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _categoryController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _categoryController.removeListener(_updateButtonState);
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.add_a_photo)),
              )
                  : Image.file(_image!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: "category Name"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _uploadCategory : null,
              child: const Text("Add category"),
            ),
          ],
        ),
      ),
    );
  }
}

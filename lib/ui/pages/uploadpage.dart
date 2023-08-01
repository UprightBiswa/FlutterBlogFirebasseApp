import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String title = '';
  String description = '';
  File? selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  String? errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
      }
    } catch (error) {
      print('Error picking image: $error');
    }
  }

  Future<String?> _uploadImage(File? image) async {
    if (image == null) return null;

    final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('images');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uploadTask = storageRef.child('$timestamp.jpg').putFile(image);

    try {
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  Future<void> _submitContent() async {
    if (_formKey.currentState!.validate() && selectedImage != null) {
      _formKey.currentState!.save();

      final imageUrl = await _uploadImage(selectedImage);

      if (imageUrl != null) {
        await FirebaseFirestore.instance.collection('blogposts').add({
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
        });

        setState(() {
          title = '';
          description = '';
          selectedImage = null;
        });

        _showDialog('Success', 'Image uploaded successfully.');
      } else {
        _showDialog('Error', 'Failed to upload image. Please try again.');
      }
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _cancelInput() {
    _formKey.currentState!.reset();
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text('Take a Photo'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text('Select from Gallery'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (selectedImage != null) ...[
                  Image.file(selectedImage!),
                  const SizedBox(height: 10),
                ],
                TextFormField(
                  onSaved: (value) {
                    // Handle the title input
                    title = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    // Handle the description input
                    description = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _cancelInput,
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitContent,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

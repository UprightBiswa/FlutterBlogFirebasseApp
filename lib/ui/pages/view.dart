import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/globals/colors.dart';

class ViewPageWidget extends StatefulWidget {
  final String documentId;
  final String imageUrl;
  final String title;
  final String description;

  ViewPageWidget({
    required this.documentId,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  _ViewPageWidgetState createState() => _ViewPageWidgetState();
}

class _ViewPageWidgetState extends State<ViewPageWidget> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _editItem() {
    String newTitle = _titleController.text;
    String newDescription = _descriptionController.text;

    FirebaseFirestore.instance
        .collection('blogposts')
        .doc(widget.documentId)
        .update({
      'title': newTitle,
      'description': newDescription,
    }).then((value) {
      // Show a snackbar or toast to indicate the item has been edited
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item updated successfully')),
      );

      // Disable editing mode
      setState(() {
        _isEditMode = false;
      });
      Navigator.pop(context);
    }).catchError((error) {
      // Handle any errors that occur during the update operation
      print('Failed to update item: $error');
    });
  }

  void _deleteItem() {
    FirebaseFirestore.instance
        .collection('blogposts')
        .doc(widget.documentId)
        .delete()
        .then((value) {
      // Show a snackbar or toast to indicate the item has been deleted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully')),
      );

      // Navigate back to the main page
      Navigator.pop(context);
    })
        .catchError((error) {
      // Handle any errors that occur during the deletion
      print('Failed to delete item: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor:  AppColors.red,
        title: Text('View Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Enable editing mode
              setState(() {
                _isEditMode = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Prompt user for confirmation before deleting
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Item'),
                    content: Text('Are you sure you want to delete this item?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          // Delete the item
                          _deleteItem();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                enabled: _isEditMode,
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptionController,
                enabled: _isEditMode,
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
              ),
            ),
            if (_isEditMode)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    // Save the changes
                    _editItem();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  String _errorMessage = '';

  Future<void> _performSearch() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('blogposts').get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> allResults = snapshot.docs;

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];

      for (var doc in allResults) {
        final String title = doc['title'] ?? '';
        if (title.toLowerCase().contains(_searchQuery.toLowerCase())) {
          results.add(doc);
        }
      }

      setState(() {
        _searchResults = results;
        _errorMessage = '';
      });
    } catch (error) {
      setState(() {
        _searchResults = [];
        _errorMessage = 'An error occurred while searching.';
      });
    }
  }


  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchResults = [];
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _performSearch();
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
              ),
            ),
            IconButton(
              onPressed: _clearSearch,
              icon: Icon(Icons.clear),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            for (var snapshot in _searchResults) ...[
              ListTile(
                onTap: () {
                  // Handle item click here
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot['imageUrl']),
                ),
                title: Text(snapshot['title']),
                subtitle: Text(snapshot['description']),
              ),
              Divider(),
            ],
          ],
        ),
      ),
    );
  }
}

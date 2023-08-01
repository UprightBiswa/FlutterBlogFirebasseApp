import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/ui/pages/view.dart';

class MainContent extends StatefulWidget {
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  bool _showAllPopularItems = false;

  // Date Widget
  Widget getDate() =>
      Container(
        alignment: Alignment.topLeft,
        child: const Text(
          "SUNDAY 4 AUGUST",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  // Profile Picture Widget
  Widget getImage() =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "Blog",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 40,
            ),
          ),
          InkWell(
            onTap: () {
              // Navigator.push(context,
              // MaterialPageRoute(builder: (context) => YourPageWidget()));
            },
            hoverColor: Colors.deepOrange,
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(12, 12)),
                image: DecorationImage(
                  image: AssetImage('assets/profile_default.jpg'),
                ),
              ),
            ),
          ),
        ],
      );

  Widget getListItem(String imageUrl, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      height: 350,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Popular Widget
  Widget popularWidget(String imageUrl, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.elliptical(12, 12)),
              image: DecorationImage(image: NetworkImage(imageUrl)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Date Widget
          getDate(),

          const SizedBox(height: 2),

          getImage(),

          const SizedBox(height: 30),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('blogposts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return const Text("No data available");
              }

              final docs = snapshot.data!.docs;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final document = docs[index];
                        final data = document.data();

                        final Map<String, dynamic>? dataMap = data as Map<
                            String,
                            dynamic>?;
                        final imageUrl = dataMap?['imageUrl'] as String? ??
                            'https://via.placeholder.com/150';
                        final title = dataMap?['title'] as String? ??
                            'No title available';
                        final description = dataMap?['description'] as String? ??
                            'No description available';

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewPageWidget(
                                      documentId: document.id,
                                      imageUrl: imageUrl,
                                      title: title,
                                      description: description,
                                    ),
                              ),
                            );
                          },
                          child: getListItem(
                            imageUrl,
                            title,
                            description,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                     const  Text(
                        "Popular",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAllPopularItems =
                            true; // Update the flag to show all popular items
                          });
                        },
                        child:  const Text(
                          "Show all",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _showAllPopularItems ? docs.length : min(
                          3, docs.length),
                      itemBuilder: (context, index) {
                        final document = docs[index];
                        final data = document.data();

                        final Map<String, dynamic>? dataMap = data as Map<
                            String,
                            dynamic>?;
                        final imageUrl = dataMap?['imageUrl'] as String? ??
                            'https://via.placeholder.com/150';
                        final title = dataMap?['title'] as String? ??
                            'No title available';
                        final description = dataMap?['description'] as String? ??
                            'No description available';

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewPageWidget(
                                      documentId: document.id,
                                      imageUrl: imageUrl,
                                      title: title,
                                      description: description,
                                    ),
                              ),
                            );
                          },
                          child: popularWidget(
                            imageUrl,
                            title,
                            description,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
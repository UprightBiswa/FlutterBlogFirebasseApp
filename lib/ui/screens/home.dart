import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/globals/colors.dart';
import 'package:flutter_firebase_auth/ui/pages/maincontent.dart';
import 'package:flutter_firebase_auth/ui/pages/searchpage.dart';
import 'package:flutter_firebase_auth/ui/pages/uploadpage.dart';
import 'package:flutter_firebase_auth/ui/screens/login.dart';
import 'package:flutter_firebase_auth/ui/widgets/user_dialog.dart';

class Home extends StatefulWidget {
  final User? user;

  const Home(this.user, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void _onBottomNavBarTap(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ShowUserInfoDialog(widget.user);
                  },
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black87, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/profile_default.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 10),
            // const Text('Homepage'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.black54,
            onPressed: _logout,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: _currentPageIndex,
        onTap: _onBottomNavBarTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_upload),
            label: 'Upload',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          SingleChildScrollView(child: MainContent()),  // Replace with your desired home page widget
          SearchPage(), // Replace with your desired search page widget
          UploadPage(), // Replace with your desired upload page widget
        ],
      ),
    );
  }
}

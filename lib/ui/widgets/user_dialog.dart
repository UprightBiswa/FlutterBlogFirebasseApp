import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/globals/colors.dart';


class ShowUserInfoDialog extends StatefulWidget {
  final User? user;

  const ShowUserInfoDialog(this.user, {Key? key}) : super(key: key);

  @override
  _ShowUserInfoDialogState createState() => _ShowUserInfoDialogState();
}

class _ShowUserInfoDialogState extends State<ShowUserInfoDialog> {
  void showUserInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Information'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkGrey2, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/profile_default.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Text(
                'User ID: ${widget.user!.uid}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'User Email: ${widget.user!.email}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showUserInfoDialog,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.darkGrey2, width: 2),
          image: const DecorationImage(
            image: AssetImage('assets/profile_default.jpg'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

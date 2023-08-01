import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/ui/screens/home.dart';
import 'package:flutter_firebase_auth/ui/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed( const Duration(seconds: 5),(){
      final user = FirebaseAuth.instance.currentUser;
      if(user == null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (cxt)=>const Login()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (cxt)=> Home(user)));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Container(
            width: 150,
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/app_icon.png"),
          ),
          const SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }
}

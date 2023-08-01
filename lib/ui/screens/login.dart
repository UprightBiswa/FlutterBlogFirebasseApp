
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/globals/colors.dart';
import 'package:flutter_firebase_auth/globals/common.dart';
import 'package:flutter_firebase_auth/ui/screens/home.dart';
import 'package:flutter_firebase_auth/ui/screens/phone_auth.dart';
import 'package:flutter_firebase_auth/ui/screens/register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/login_card.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailCtrl =TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  void _signinWithEmailPassword() async {
    try {
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text,
        password: _pwdCtrl.text,
      );
      final user = credentials.user;
      if (user != null) {
        if (mounted) {
          showSnackBer(context, "Successfully logged in", null);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (cxt) => Home(user)),
                (route) => false,
          );
        }
      } else {
        if (mounted) {
          showSnackBer(context, "Some error occurred in logging in. Try again.", null);
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'wrong-password') {
        showSnackBer(context, "Wrong password", null);
      } else if (e.code == 'user-not-found') {
        showSnackBer(context, "User not found", null);
      } else {
        showSnackBer(context, e.code, null);
      }
    } catch (e) {
      print(e);
      showSnackBer(context, "Some error occurred", null);
    }
  }
  void _recoverPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailCtrl.text);
      if (mounted) {
        showSnackBer(context, "Password reset email sent", null);
      }
    } catch (e) {
      print(e);
      showSnackBer(context, "Failed to send password reset email", null);
    }
  }
  void _signinAnonymously() async {
    try {
      final credentials = await FirebaseAuth.instance.signInAnonymously();
      final user = credentials.user;
      if (user != null) {
        if (mounted) {
          showSnackBer(context, "Successfully logged in", null);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (cxt)=> Home(user)),
              (route)=>false);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      showSnackBer(context, "some error occurred", null);
    }
  }
  void _googleSignin() async{
    try{
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? gAuth = await googleUser?.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken,
          idToken: gAuth?.idToken,
        );
        final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final user = firebaseCredential.user;
        if(user == null){
          if(mounted){
            showSnackBer(context, "some error occurred", null);
          }
        }else{
          if(mounted){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (cxt)=>Home(user)),
                (route) => false);
          }
        }
    }catch(e){
      print(e);
      showSnackBer(context, "some error occurred", null);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100, bottom: 30, left: 20, right: 20),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hello Again!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Welcome back, you have been missed!',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.darkGrey1),
                  ),
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter email',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _pwdCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter password',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 16, left: 15, right: 15),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _recoverPassword,
                    child: const Text(
                      "Recover password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: _signinWithEmailPassword,
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors.red,
                ),
                child: const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: _signinAnonymously,
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors.red,
                ),
                child: const Center(
                  child: Text(
                    'Sign in annonymously',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
              child: const Center(
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      'Or continue with',
                      style: TextStyle(
                        color: AppColors.darkGrey1,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LoginCard(
                    onTap: null,
                    imgPath: 'assets/email.png',
                  ),
                  LoginCard(
                    onTap: _googleSignin,
                    imgPath: 'assets/google.png',
                  ),
                   LoginCard(
                    onTap: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (cxt)=>const PhoneAuth()));
                    },
                    imgPath: 'assets/phone.png',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      'Not a member? Register now',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

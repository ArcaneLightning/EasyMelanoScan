import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:melanoma_detection/center/center.dart';
import 'package:melanoma_detection/login/login.dart';
import 'package:melanoma_detection/login/verify.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading", textDirection: TextDirection.ltr,);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("error", textDirection: TextDirection.ltr,),
          );
        } else if (snapshot.hasData) {
          return const CenterScreen();
        } else {
          return const LoginScreen();
        }
      }
    );
  }
}
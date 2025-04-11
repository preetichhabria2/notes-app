import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'loginscreen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If the user is logged in and their email is verified, navigate to HomeScreen
    if (user != null && user.emailVerified) {
      return const HomeScreen();
    } else {
      // If the user is not logged in or email is not verified, show LoginScreen
      return const Loginscreen();
    }
  }
}

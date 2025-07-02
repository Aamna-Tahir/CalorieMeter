import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calorieMeter/dashboard.dart';
import 'package:calorieMeter/welcome.dart';
import 'package:calorieMeter/nameinputscreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), checkLoginStatus);
  }

  Future<void> checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // 🔴 Not logged in → Go to welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const welcome()),
      );
    } else {
      // ✅ Logged in → Check if onboarding was completed
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final hasCompleted = doc.data()?['hasCompletedOnboarding'] ?? false;

      if (hasCompleted == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const dashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NameInputScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 206, 243, 164),
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}

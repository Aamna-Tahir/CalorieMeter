import 'dart:async';
import 'package:calorieMeter/welcome.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => welcome(),
        ),
      );
    });
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

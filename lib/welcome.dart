import 'package:calorieMeter/auth_service.dart';
import 'package:calorieMeter/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:calorieMeter/signup.dart';
import 'login.dart';

class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    height: 150,
                    width: 130,
                    image: AssetImage('assets/logoIcon.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to ',
                          style: TextStyle(
                              fontSize: 26, fontFamily: 'Lora', color: Colors.black),
                        ),
                        Text(
                          'CalorieMeter!',
                          style: TextStyle(
                              fontSize: 26, fontFamily: 'Lora', color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: Text(
                        'Your AI-Powered Nutrition Coach',
                        style: TextStyle(fontSize: 17, fontFamily: 'Lora', color: Colors.black),
                      )),
                ],
              ),
              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: 280,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const login()),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 22, fontFamily: 'Lora', color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Signup Button
              SizedBox(
                width: 280,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const signup()),
                    );
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(fontSize: 22, fontFamily: 'Lora', color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // OR Divider
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Lora'),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Google Button
              SizedBox(
                width: 280,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,  // Clean look
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.grey),  // Adds a Google-like border
                    ),
                    elevation: 2, // Slight shadow for premium feel
                  ),
                 onPressed: () async {
                    final userCred = await AuthService().signInWithGoogle();
                    if (userCred != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const dashboard()),
                      );
                    } else {
                      // Ensures the context has a Scaffold
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Google Sign-In Failed")),
                        );
                      });
                    }
                  },

                  icon: Image.asset('assets/google.png', height: 24, width: 24), // Google icon
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 17, fontFamily: 'Lora', color: Colors.black),
                  ),
                ),
              ),


            
            ],
          ),
        ),
      ),
    );
  }
}

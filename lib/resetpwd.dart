import 'package:flutter/material.dart';
//import 'package:calorieMeter/otp.dart';
import 'login.dart';

class resetpwd extends StatelessWidget {
  const resetpwd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Lock Icon at the top
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,

                  ),
                  child: const Icon(
                    Icons.lock_reset_outlined,
                    size: 140,
                    color: Colors.black,
                  ),
                ),

                // Forgot Password Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    'Reset Password?',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lora',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    "No worries! We'll send you a reset code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lora',
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 340.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.green,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Label
                      const Text(
                        'Enter your email:',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lora',
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Fixed Email Text Field
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 17,
                              fontFamily: 'Lora',
                              color: Color(0xFF194D33),
                            ),
                            fillColor: const Color(0xffF8F9FA),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xffE4E7E8)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xffE4E7E8), width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined,size: 20,color: Colors.black ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Reset Password Button
                      SizedBox(
                        width: 300,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(

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
                            'Reset Password',
                            style: TextStyle(fontSize: 21, fontFamily: 'Lora', color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const login(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Back to Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }}

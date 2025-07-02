import 'package:calorieMeter/otp.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class forgotPwd extends StatefulWidget {
  const forgotPwd({super.key});

  @override
  _ForgotPwdState createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<forgotPwd> {
  final TextEditingController emailController = TextEditingController(); // Controller for email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Lock Icon at the top
                Container(
                  padding: const EdgeInsets.all(20),
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
                    'Forgot Password?',
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

                      // Email Text Field
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: emailController,  // Store email input
                          keyboardType: TextInputType.emailAddress,
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
                            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Colors.black),
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
                            String email = emailController.text.trim(); // Get entered email

                            if (email.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => otp(email: email)), // Passing email
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please enter a valid email")),
                              );
                            }
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const login()),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white, size: 18),
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
  }
}

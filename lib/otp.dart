import 'package:flutter/material.dart';
import 'package:calorieMeter/login.dart';

class otp extends StatelessWidget {
  otp({super.key});

  final List<TextEditingController> controllers =
  List.generate(4, (index) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Ensures the scaffold adjusts when the keyboard appears
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // Adding dynamic bottom padding based on keyboard visibility
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 70),
                // Email Icon
                const Icon(Icons.email_outlined, size: 70, color: Colors.black),
                const SizedBox(height: 20),
                // Text Heading
                const Text(
                  "We Have Sent Code\nNumber To Your Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Lora',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                // Subheading
                const Text(
                  "Enter the digits here:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lora',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 25),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Center(
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lora',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < 3) {
                                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 17),
                // Resend Email Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Haven't received an email?",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Lora',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Resend OTP Function
                      },
                      child: const Text(
                        "Send Email Again",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Confirm Button
                GestureDetector(
                  onTap: () {
                    String otpCode = controllers.map((e) => e.text).join();
                    if (otpCode.length == 4) {
                      print("Entered OTP: $otpCode"); // Replace with verification logic
                    }
                  },
                  child: SizedBox(
                    width: 300,
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
                        'Confirm',
                        style: TextStyle(fontSize: 21, fontFamily: 'Lora', color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

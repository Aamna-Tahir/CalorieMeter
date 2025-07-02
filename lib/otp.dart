import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:calorieMeter/login.dart';

class otp extends StatefulWidget {
  final String email;

  const otp({super.key, required this.email});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<otp> {
  final List<TextEditingController> controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(4, (index) => FocusNode());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String generatedOtp;

  @override
  void initState() {
    super.initState();
    generatedOtp = generateOtp();
    sendOtpToEmail(widget.email, generatedOtp);
  }

  String generateOtp() {
    Random random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> sendOtpToEmail(String email, String otp) async {
    try {
      // Store OTP in Firestore
      await _firestore.collection("otps").doc(email).set({
        "otp": otp,
        "timestamp": Timestamp.now(),
      });

      // Send OTP via SendGrid
      const String apiKey = "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";
      const String fromEmail = "malaika.kaleem4@gmail.com"; // Verified sender email
      const String subject = "Password Reset OTP – Secure Your Account";
      final String message = "You have requested to reset your password. Please use the following One-Time Password (OTP) to proceed:\n"
          "Your OTP: $otp \n\n"
          "Do not share this code with anyone for security reasons. If you did not request a password reset, please ignore this email or contact our support team immediately.\n\n"
          "Best regards,\n"
          "CalorieMeter";

      final Uri url = Uri.parse("https://api.sendgrid.com/v3/mail/send");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "personalizations": [
            {
              "to": [
                {"email": email}
              ],
              "subject": subject
            }
          ],
          "from": {"email": fromEmail},
          "content": [
            {"type": "text/plain", "value": message}
          ]
        }),
      );

      if (response.statusCode == 202) {
        print("OTP Sent to $email");
      } else {
        print("Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  void verifyOtp() async {
    String enteredOtp = controllers.map((e) => e.text).join();

    // Fetch OTP from Firestore
    DocumentSnapshot otpDoc =
    await _firestore.collection("otps").doc(widget.email).get();

    if (otpDoc.exists && otpDoc["otp"] == enteredOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const Icon(Icons.email_outlined, size: 70, color: Colors.black),
                const SizedBox(height: 20),
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
                        sendOtpToEmail(widget.email, generatedOtp);
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
                GestureDetector(
                  onTap: verifyOtp,
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
                      onPressed: verifyOtp,
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

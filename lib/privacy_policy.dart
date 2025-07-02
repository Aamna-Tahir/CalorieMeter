import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your privacy matters to us.",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This policy outlines how we handle your information within the app.",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            _sectionTitle("1. Information Collected"),
            _sectionText(
                "- Name, email (if provided)\n- Anonymous usage statistics"),

            _sectionTitle("2. How We Use It"),
            _sectionText(
                "- To improve app features and personalize experience\n- For support and functionality"),

            _sectionTitle("3. Data Sharing"),
            _sectionText(
                "- We do not sell your data\n- Only share with trusted services if needed"),

            _sectionTitle("4. Your Rights"),
            _sectionText(
                "- You can request access or deletion of your data anytime"),

            _sectionTitle("5. Data Security"),
            _sectionText(
                "- We apply reasonable measures to protect your information"),

            _sectionTitle("6. Contact Us"),
            _sectionText("Email: caloriemeter@gmail.com"),

            const SizedBox(height: 20),
            const Center(
              child: Text(
                "By using this app, you accept this privacy policy.",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

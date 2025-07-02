import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
        title: const Text("Terms & Conditions"),
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
              "Welcome to CalorieMeter!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "These Terms govern your use of CalorieMeter. By using our app, you agree to the following:",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),

            _sectionTitle("1. Eligibility"),
            _sectionText("You must be 16+ years old to use CalorieMeter."),

            _sectionTitle("2. Account Responsibility"),
            _sectionText(
              "Provide accurate info. You're responsible for your login and activity.",
            ),

            _sectionTitle("3. Service Usage"),
            _sectionText(
              "CalorieMeter helps users manage goals and health tracking. We are not liable for user-generated content or results.",
            ),

            _sectionTitle("4. Payments"),
            _sectionText(
              "Fees, if applicable, are billed monthly. Payments are non-refundable unless otherwise stated.",
            ),

            _sectionTitle("5. User Conduct"),
            _sectionText(
              "- No illegal, misleading, or harmful use\n- Be respectful in your content\n- Follow local laws",
            ),

            _sectionTitle("6. Content Ownership"),
            _sectionText(
              "You own your content but grant us rights to use it for improving or promoting the app.",
            ),

            _sectionTitle("7. Termination"),
            _sectionText(
              "We may suspend access for violations of these terms or misuse of the app.",
            ),

            _sectionTitle("8. Liability Disclaimer"),
            _sectionText(
              "We don’t guarantee specific results. Use of the app is at your own risk.",
            ),

            _sectionTitle("9. Changes to Terms"),
            _sectionText(
              "We may update these Terms. Continued use means you accept the changes.",
            ),

            _sectionTitle("10. Governing Law"),
            _sectionText(
              "These Terms are governed by the laws of the State of Pakistan.",
            ),

            _sectionTitle("11. Contact Us"),
            _sectionText(
              "For questions, email us at: caloriemeter@gmail.com",
              
            ),

            const SizedBox(height: 20),
            const Center(
              child: Text(
                "By using CalorieMeter, you agree to these Terms & Conditions.",
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

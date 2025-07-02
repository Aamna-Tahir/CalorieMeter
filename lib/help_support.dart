import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final String supportEmail = 'caloriemeter@gmail.com';

  void _launchEmail(String subject) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=${Uri.encodeComponent(subject)}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I track my daily calories?',
      'answer': 'Go to the Home screen and use the Scan or Diet Plan feature to log your meals.',
    },
    {
      'question': 'Can I customize my diet plan?',
      'answer': 'Yes, under the Diet Plan screen, you can adjust your preferences and goals.',
    },
    {
      'question': 'How do I reset my progress?',
      'answer': 'Navigate to Profile > Settings > Reset Progress to clear your data.',
    },
    {
      'question': 'How do I scan food items?',
      'answer': 'Use the Scan feature from the bottom menu to analyze food labels or meals.',
    },
    {
      'question': 'How can I change my personal goals?',
      'answer': 'Tap the Profile tab and select "Edit Goals" to update your calorie and activity targets.',
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, we use secure methods to store and handle your data responsibly.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...faqs.map((faq) => ExpansionTile(
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.expand_more),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 24),

            const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Need help or have feedback? Reach out to us via email:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              supportEmail,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _launchEmail('Feedback from Calorie Meter App'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Send Feedback',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _launchEmail('Bug Report - Calorie Meter App'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Report a Bug',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

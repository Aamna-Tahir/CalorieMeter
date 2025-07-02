import 'package:calorieMeter/onboarding_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'more_user_info.dart';

class PreferencesOnboarding extends StatefulWidget {
  const PreferencesOnboarding({super.key});

  @override
  _PreferencesOnboardingState createState() => _PreferencesOnboardingState();
}

class _PreferencesOnboardingState extends State<PreferencesOnboarding> {
  final Map<String, bool> dietaryPreferences = {
    'Vegan': false,
    'Vegetarian': false,
    'Pescetarian': false,
    'Flexitarian': false,
  };

  void _savePreferences() async {
    final selectedPreferences = dietaryPreferences.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    OnboardingDataService().dietaryPreferences = selectedPreferences;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'dietaryPreferences': selectedPreferences,
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MoreUserInfo()),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
      ),
    );
  }

  Widget _checkboxList() {
    return Column(
      children: dietaryPreferences.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          activeColor: Colors.green,
          checkColor: Colors.white,
          value: dietaryPreferences[key],
          onChanged: (bool? value) {
            setState(() {
              dietaryPreferences[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Preferences", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index < 6 ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text(
              "Any dietary preferences?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("This helps us personalize your meal suggestions.", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 24),
            _sectionTitle('Select all that apply'),
            _checkboxList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.lightGreen[50],
                child: const Icon(Icons.arrow_back, color: Colors.green),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

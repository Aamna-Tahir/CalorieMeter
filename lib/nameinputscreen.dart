import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'GoalsTutorialScreen.dart';
import 'onboarding_data_service.dart';
import 'package:flutter/services.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isValidName = false;
  DateTime? _lastBackPressed;

  void _validateName(String name) {
    final isValid = RegExp(r'^[a-zA-Z]+$').hasMatch(name);
    setState(() {
      isValidName = isValid;
    });
  }

  Future<void> _handleBackPress() async {
    final now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      if (Platform.isAndroid) {
        await Fluttertoast.cancel(); // Avoid stacking
        await Fluttertoast.showToast(msg: 'Press back again to exit the app');
      }
    } else {
      // Exit app
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) await _handleBackPress();
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text(
                "First, what can we call you?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("We’d like to get to know you.", style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 28),
              Text("Preferred first name", style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                onChanged: _validateName,
                decoration: InputDecoration(
                  hintText: "Your name",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isValidName
                  ? () {
                      OnboardingDataService().name = _nameController.text.trim();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => GoalsTutorialScreen()),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValidName ? Colors.green : Colors.green.withOpacity(0.5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

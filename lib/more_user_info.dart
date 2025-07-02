import 'package:calorieMeter/preferences_onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:calorieMeter/onboarding_data_service.dart';

class MoreUserInfo extends StatefulWidget {
  const MoreUserInfo({super.key});

  @override
  State<MoreUserInfo> createState() => _MoreUserInfoState();
}

class _MoreUserInfoState extends State<MoreUserInfo> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _goalWeightController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool _isCm = true;
  bool _isKg = true;

  void _toggleHeightUnit() {
    setState(() {
      _isCm = !_isCm;
      _heightController.clear();
      _heightFeetController.clear();
      _heightInchesController.clear();
    });
  }

  void _toggleWeightUnit() {
    setState(() {
      _isKg = !_isKg;
      _weightController.clear();
      _goalWeightController.clear();
    });
  }

  void _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      double height = _isCm
          ? double.parse(_heightController.text)
          : (int.parse(_heightFeetController.text) * 30.48 + int.parse(_heightInchesController.text) * 2.54);
      double weight = double.parse(_weightController.text);
      double goalWeight = double.parse(_goalWeightController.text);

      final onboardingService = OnboardingDataService.instance;
      onboardingService.height = height;
      onboardingService.weight = weight;
      onboardingService.goalWeight = goalWeight;
      

      await onboardingService.saveToFirestore(uid);
      onboardingService.reset();

      //logic onboarding
      await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'hasCompletedOnboarding': true});

      //set flag true

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const dashboard()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'You',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // Updated Progress Bar
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    flex: 1,
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < 6 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Just a few more questions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _isCm
                        ? _buildInputField(
                            controller: _heightController,
                            label: 'How tall are you?',
                            hint: 'e.g. 170',
                            unit: 'cm',
                            onUnitTap: _toggleHeightUnit,
                            validatorMsg: 'Please enter valid height',
                            green: green,
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _heightFeetController,
                                  label: 'Height (ft)',
                                  hint: 'e.g. 5',
                                  unit: 'ft',
                                  onUnitTap: _toggleHeightUnit,
                                  validatorMsg: 'Please enter feet',
                                  green: green,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInputField(
                                  controller: _heightInchesController,
                                  label: 'Height (in)',
                                  hint: 'e.g. 7',
                                  unit: 'in',
                                  onUnitTap: _toggleHeightUnit,
                                  validatorMsg: 'Please enter inches',
                                  green: green,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _weightController,
                      label: 'How much do you weigh?',
                      hint: 'e.g. 60',
                      unit: _isKg ? 'kg' : 'lb',
                      onUnitTap: _toggleWeightUnit,
                      validatorMsg: 'Please enter valid weight',
                      green: green,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _goalWeightController,
                      label: "What's your goal weight?",
                      hint: 'e.g. 55',
                      unit: _isKg ? 'kg' : 'lb',
                      onUnitTap: null,
                      validatorMsg: 'Please enter valid goal weight',
                      green: green,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.green),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => PreferencesOnboarding()),
                      );
                    },
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.green.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Next", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String unit,
    required String validatorMsg,
    required Color green,
    void Function()? onUnitTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  final numVal = double.tryParse(value ?? '');
                  if (numVal == null || numVal <= 0) {
                    return validatorMsg;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onUnitTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(unit, style: TextStyle(color: green)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

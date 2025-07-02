import 'package:calorieMeter/preferences_onboarding.dart';
import 'package:flutter/material.dart';
import 'user_activity_level.dart';
import 'onboarding_data_service.dart';
import 'package:flutter/services.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String? _selectedGender;
  String _age = '';
  String? _genderError;
  String? _ageError;
  String? _otherAllergyError;
  bool _isLoading = false;

  final List<String> _allergyOptions = [
    'Peanuts',
    'Tree nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'None',
    'Other'
  ];
  List<String> _selectedAllergies = [];
  String _otherAllergy = '';

  bool get _isFormValid =>
      _selectedGender != null && _age.isNotEmpty;

  void _validateAndSubmit() async {
    setState(() {
      _genderError = _selectedGender == null ? 'Please select a gender' : null;

      if (_age.isEmpty) {
        _ageError = 'Age is required';
      } else {
        final ageValue = int.tryParse(_age);
        if (ageValue == null || ageValue < 5 || ageValue > 100) {
          _ageError = 'Age must be between 5 and 100';
        } else {
          _ageError = null;
        }
      }

      if (_selectedAllergies.contains("Other")) {
        if (_otherAllergy.trim().isEmpty) {
          _otherAllergyError = 'Please specify your allergy';
        } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(_otherAllergy)) {
          _otherAllergyError = 'Only letters are allowed';
        } else {
          _otherAllergyError = null;
        }
      } else {
        _otherAllergyError = null;
      }
    });

    if (!_isFormValid || _otherAllergyError != null) return;

    try {
      setState(() => _isLoading = true);

      final List<String> finalAllergies = List.from(_selectedAllergies);
      if (finalAllergies.contains("Other")) {
        finalAllergies.remove("Other");
        finalAllergies.add(_otherAllergy.trim());
      }

      final onboarding = OnboardingDataService();
      onboarding.gender = _selectedGender;
      onboarding.age = int.parse(_age);
      onboarding.allergies = finalAllergies;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PreferencesOnboarding()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("You", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Row(
                                    children: List.generate(7, (index) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: index < 6 ? 4.0 : 0.0),
                                        child: Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: index < 5 ? Colors.green : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      );
                                    }),

                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Tell us a little bit about yourself",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Text(
                                "Please select which gender we should use to calculate your calorie needs:",
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      activeColor: Colors.green,
                                      title: Text("Male"),
                                      value: "Male",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      activeColor: Colors.green,
                                      title: Text("Female"),
                                      value: "Female",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_genderError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(_genderError!, style: TextStyle(color: Colors.red)),
                              ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                              child: Text("How old are you?",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (value) {
                                  setState(() {
                                    _age = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorText: _ageError,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Text(
                                "We use gender and age to calculate an accurate goal for you.",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                              child: Text("Do you have any food allergies?",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: _allergyOptions.map((option) {
                                  final isSelected = _selectedAllergies.contains(option);
                                  return FilterChip(
                                    label: Text(option),
                                    selected: isSelected,
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Colors.green[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedAllergies.add(option);
                                        } else {
                                          _selectedAllergies.remove(option);
                                          if (option == "Other") _otherAllergy = '';
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            if (_selectedAllergies.contains("Other"))
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: "Please specify",
                                    errorText: _otherAllergyError,
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _otherAllergy = value;
                                      _otherAllergyError = null;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.green),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => UserActivityLevel()),
                                );
                              },
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _validateAndSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  disabledBackgroundColor: Colors.green.withOpacity(0.4),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text("Next", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

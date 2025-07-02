import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:calorieMeter/login.dart';
//import 'package:calorieMeter/dashboard.dart';
import 'package:calorieMeter/auth_service.dart';
import 'nameinputscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _contact = TextEditingController();

  bool isChecked = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _nameError;
  String? _emailError;
  String? _contactError;
  String? _passwordError;
  String? _confirmPasswordError;

  String _passwordStrength = '';
  double _strengthPercent = 0.0;
  Color _strengthColor = Colors.red;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _contact.dispose();
    super.dispose();
  }

  bool _isAlphabetOnly(String text) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  bool _isValidEmail(String email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  bool _isValidContact(String contact) => RegExp(r'^\d{11}$').hasMatch(contact);

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 6) {
        _passwordStrength = "Weak";
        _strengthPercent = 0.3;
        _strengthColor = Colors.red;
      } else if (password.length < 10) {
        _passwordStrength = "Medium";
        _strengthPercent = 0.6;
        _strengthColor = Colors.orange;
      } else {
        _passwordStrength = "Strong";
        _strengthPercent = 1.0;
        _strengthColor = Colors.green;
      }
    });
  }
  String _capitalizeName(String input) {
  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

  bool _validateFields() {
    setState(() {
     final trimmedName = _name.text.trim();
          final capitalized = _capitalizeName(trimmedName);
          _nameError = trimmedName.isEmpty
              ? 'Name is required'
              : !_isAlphabetOnly(trimmedName)
                  ? 'Only alphabets allowed'
                  : trimmedName.length > 30
                      ? 'Name must be under 30 characters'
                      : null;

          if (_nameError == null && _name.text != capitalized) {
            _name.text = capitalized;
            _name.selection = TextSelection.fromPosition(TextPosition(offset: _name.text.length));
          }


      _emailError = _email.text.isEmpty
          ? 'Email is required'
          : !_isValidEmail(_email.text)
              ? 'Invalid email format'
              : null;

      _passwordError = _password.text.isEmpty
          ? 'Password is required'
          : _passwordStrength == 'Weak'
              ? 'Password is too weak'
              : null;

      _confirmPasswordError = _confirmPassword.text.isEmpty
          ? 'Confirm your password'
          : _password.text != _confirmPassword.text
              ? 'Passwords do not match'
              : null;

        if (_contact.text.isNotEmpty && !_isValidContact(_contact.text)) {
          _contactError = 'Phone must be 11 digits';
        } else {
          _contactError = null;
        }       
    });

    return [_nameError, _emailError, _contactError, _passwordError, _confirmPasswordError]
        .every((e) => e == null);
  }

  _signup() async {
    if (!_validateFields()) return;

    try {
      final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
      if (user != null) {
        log("User Created Successfully");

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _name.text.trim(),
          'email': user.email,
          if (_contact.text.trim().isNotEmpty) 'phoneNumber': _contact.text.trim(),
          'hasCompletedOnboarding': false,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NameInputScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Signup failed');
    } catch (e) {
      _showErrorDialog('Something went wrong. Please try again.');
      log("Other error: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Signup Error"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, Icon icon, String? error) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 17, fontFamily: 'Lora', color: Colors.black),
      fillColor: const Color(0xffF8F9FA),
      filled: true,
      errorText: error,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: error != null ? Colors.red : const Color(0xffE4E7E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: error != null ? Colors.red : const Color(0xffE4E7E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Image(height: 140, width: 90, image: AssetImage('assets/logoIcon.png')),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Let’s Create Your Account!',
                      style: TextStyle(fontSize: 30, fontFamily: 'Lora', color: Colors.black),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text('Already Registered?', style: TextStyle(fontSize: 18, fontFamily: 'Lora')),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const login())),
                      child: const Text(
                        ' Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Lora',
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _name,
                    maxLength: 30,
                    decoration: _inputDecoration('Enter your name', const Icon(Icons.person), _nameError),
                  ),
                ),
                const SizedBox(height: 15),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _email,
                    decoration: _inputDecoration('Enter your email', const Icon(Icons.email_outlined), _emailError),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _password,
                        obscureText: _obscurePassword,
                        onChanged: _checkPasswordStrength,
                        decoration: _inputDecoration('Enter your password', const Icon(Icons.lock_open), _passwordError)
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: _strengthPercent,
                        color: _strengthColor,
                        backgroundColor: Colors.grey[300],
                      ),
                      Text(
                        _passwordStrength,
                        style: TextStyle(color: _strengthColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Confirm Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _confirmPassword,
                    obscureText: _obscureConfirmPassword,
                    decoration: _inputDecoration('Confirm your password', const Icon(Icons.lock_open), _confirmPasswordError)
                        .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _contact,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('Enter your contact (optional)', const Icon(Icons.phone), _contactError),
                  ),
                ),
                const SizedBox(height: 10),

                // Terms Checkbox
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) => setState(() => isChecked = val!),
                        activeColor: Colors.green,
                      ),
                      const Expanded(
                        child: Text(
                          'By continuing, you agree with our Terms & Conditions and Privacy Policy.',
                          style: TextStyle(fontSize: 16, fontFamily: 'Lora'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Signup Button
                SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: _signup,
                    child: const Text(
                      'Signup',
                      style: TextStyle(fontSize: 22, fontFamily: 'Lora', color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

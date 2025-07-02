import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calorieMeter/login.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _errorText;
  String _passwordStrength = "";

  final _auth = FirebaseAuth.instance;

  void _checkPasswordStrength(String password) {
    if (password.length < 6) {
      setState(() => _passwordStrength = "Weak");
    } else if (password.length < 10) {
      setState(() => _passwordStrength = "Medium");
    } else {
      setState(() => _passwordStrength = "Strong");
    }
  }

  Future<void> _changePassword() async {
    setState(() => _errorText = null);

    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (newPass.length < 6) {
      setState(() => _errorText = "New password must be at least 6 characters.");
      return;
    }

    if (newPass != confirmPass) {
      setState(() => _errorText = "New passwords do not match.");
      return;
    }

    try {
      final user = _auth.currentUser!;
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPass,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPass);
      await _auth.signOut();

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const login()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.code == "wrong-password"
            ? "Old password is incorrect."
            : "Failed to change password.";
      });
    }
  }

  InputDecoration _buildInputDecoration(String hint, bool obscure, VoidCallback toggleVisibility) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
        onPressed: toggleVisibility,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Old Password"),
              const SizedBox(height: 6),
              TextField(
                controller: _oldPasswordController,
                obscureText: _obscureOld,
                decoration: _buildInputDecoration("Old Password", _obscureOld, () {
                  setState(() => _obscureOld = !_obscureOld);
                }),
              ),
              const SizedBox(height: 20),

              const Text("New Password"),
              const SizedBox(height: 6),
              TextField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                onChanged: _checkPasswordStrength,
                decoration: _buildInputDecoration("New Password", _obscureNew, () {
                  setState(() => _obscureNew = !_obscureNew);
                }),
              ),
              const SizedBox(height: 8),
              Text(
                _passwordStrength.isNotEmpty ? "Strength: $_passwordStrength" : "",
                style: TextStyle(
                  fontSize: 14,
                  color: _passwordStrength == "Weak"
                      ? Colors.red
                      : _passwordStrength == "Medium"
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              const Text("Confirm New Password"),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: _buildInputDecoration("Confirm Password", _obscureConfirm, () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                }),
              ),
              const SizedBox(height: 20),

              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorText!, style: const TextStyle(color: Colors.red)),
                ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

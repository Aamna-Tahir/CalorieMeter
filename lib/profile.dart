import 'dart:io';
import 'package:calorieMeter/help_support.dart';
import 'package:calorieMeter/login.dart';
import 'package:calorieMeter/privacy_policy.dart';
import 'package:calorieMeter/settings.dart';
import 'package:calorieMeter/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calorieMeter/set_profile.dart';
import 'auth_service.dart';
import 'package:calorieMeter/preferences.dart';
import 'account_page.dart';
import 'allergies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  File? _image;
  bool _isNameLoaded = false;
  String _username = '';
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _username = data['name'] ?? '';
          _isNameLoaded = true;
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted || await Permission.mediaLibrary.isGranted) {
        return;
      }
      var status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gallery permission is required')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermission();
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_image != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
          ],
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture removed')),
    );
  }

  void _logout() async {
    await auth.signout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const login()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.person, size: 58, color: Colors.black54)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _isNameLoaded
                    ? Text(
                        'Hello $_username!',
                        key: ValueKey(_username),
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 15),
              _buildMenuItem(Icons.person, 'Account', 'Manage profile, Change password', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              }),
              _buildMenuItem(Icons.edit, 'Set Your Profile', 'Add age, weight, height, goals', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetProfile()),
                );
              }),
              _buildMenuItem(Icons.restaurant_menu, 'Diet Preferences', 'Vegan, Fast food, and more', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Preferences()),
                );
              }),
              _buildMenuItem(Icons.health_and_safety, 'Set Allergies', 'Choose foods you’re allergic to', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllergiesScreen()),
                );
              }),
              _buildMenuItem(Icons.notifications, 'Notifications', 'Manage reminders and alerts', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }),
              _buildMenuItem(Icons.help_outline, 'Help & Support', 'FAQs and contact support', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              }),
              _buildMenuItem(Icons.policy, 'Privacy Policy', 'View data security practices', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                );
              }),
              _buildMenuItem(Icons.cloud_sync, 'Terms & Conditions', 'Review usage rules and platform policies.', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
                );
              }),
              _buildMenuItem(Icons.logout, 'Log Out', 'Sign out from your account', () {
                _logout();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontFamily: 'Lora',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Lora',
          color: Colors.black54,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

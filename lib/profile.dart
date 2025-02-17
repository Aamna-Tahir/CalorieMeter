import 'dart:io';
import 'package:calorieMeter/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calorieMeter/set_profile.dart';
import 'auth_service.dart';
import 'resetpwd.dart';
import 'package:calorieMeter/preferences.dart';
class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  File? _image;
  final AuthService auth = AuthService();


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
    await auth.signout(); // Assuming 'auth' is your auth service
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => login()),
    );
     // Assuming this navigates to the login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 22),
              // Profile Picture Section
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
              // Username
              const Text(
                'Hello User!',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              _buildMenuItem(Icons.person, 'Account', 'Manage profile, Reset password', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const resetpwd()),
                  );
                },
              ),
              _buildMenuItem(Icons.policy, 'Privacy Policy', 'View data security practices', (){}),
              _buildMenuItem(Icons.edit, 'Set Your Profile', 'Add age, weight, height, goals',() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetProfile()),
                );
              },
              ),
              _buildMenuItem(Icons.restaurant_menu, 'Diet Preferences', 'Vegan, Fast food, and more',() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Preferences()),
                );
              },),
              _buildMenuItem(Icons.notifications, 'Notifications', 'Manage reminders and alerts',(){}),
              _buildMenuItem(Icons.palette, 'App Appearance', 'Themes, fonts, and display',(){}),
              _buildMenuItem(Icons.cloud_sync, 'Data & Sync', 'Backup and sync with Google Account',(){}),
              _buildMenuItem(Icons.groups, 'Community Settings', 'Manage visibility and privacy',(){}),
              _buildMenuItem(Icons.emoji_events, 'Health Challenges', 'Join or create challenges',(){}),
              _buildMenuItem(Icons.help_outline, 'Help & Support', 'FAQs and contact support',(){}),
              _buildMenuItem(Icons.logout, 'Log Out', 'Sign out from your account',(){ _logout();}),
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

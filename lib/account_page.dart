import 'package:calorieMeter/change_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification_service.dart';
import 'welcome.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;

  String email = '';
  String phoneNumber = '';
  bool allowNotifications = true;

  final _dialogController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadNotificationPreference();
  }

  Future<void> _loadUserInfo() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    if (doc.exists && mounted) {
      final data = doc.data()!;
      setState(() {
        email = data['email'] ?? '';
        phoneNumber = data['phoneNumber'] ?? '';
      });
    }
  }

  Future<void> _updateUserField(String field, String value) async {
    if (user == null) return;

    try {
      if (field == 'email') {
        await user!.verifyBeforeUpdateEmail(value); // Send confirmation email
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({field: value});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              field == 'email'
                  ? 'Verification email sent. Please confirm from your new email.'
                  : '$field updated successfully.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _loadUserInfo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _promptReauthentication(field, value);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update $field: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _promptReauthentication(String field, String newValue) {
    final passwordController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Re-authenticate to continue'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please enter your password to continue.'),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: errorText,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.green)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final password = passwordController.text.trim();
                  try {
                    final cred = EmailAuthProvider.credential(
                      email: user!.email!,
                      password: password,
                    );
                    await user!.reauthenticateWithCredential(cred);
                    Navigator.pop(context);
                    _updateUserField(field, newValue); // Retry update
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      errorText = e.code == 'wrong-password'
                          ? 'Incorrect password'
                          : 'Failed to reauthenticate';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

 Future<void> _deleteAccount() async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).delete();
    await user?.delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted successfully")),
      );

      // Navigate to Welcome(0)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const welcome()),
        (route) => false,
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: $e")),
      );
    }
  }
}


  void _showDeleteDialog() {
    final passwordController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm Account Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your password to delete your account:'),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: errorText,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final password = passwordController.text.trim();
                try {
                  final cred = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: password,
                  );
                  await user!.reauthenticateWithCredential(cred);
                  Navigator.pop(context);
                  _deleteAccount();
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    errorText = e.code == 'wrong-password'
                        ? 'Password is incorrect.'
                        : 'Reauthentication failed.';
                  });
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      allowNotifications = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _updateNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  void _showEditDialog({
    required String title,
    required String initialValue,
    required String fieldType,
    required Function(String) onSave,
  }) {
    _dialogController.text = initialValue;
    showDialog(
      context: context,
      builder: (context) {
        String? errorText;
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: TextField(
            controller: _dialogController,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldType',
              errorText: errorText,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            keyboardType:
                fieldType == 'phone' ? TextInputType.phone : TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                final value = _dialogController.text.trim();
                if (fieldType == 'email' &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  setState(() => errorText = 'Enter valid email');
                  return;
                }
                if (fieldType == 'phone' && !RegExp(r'^\d{11}$').hasMatch(value)) {
                  setState(() => errorText = 'Phone must be 11 digits');
                  return;
                }

                Navigator.pop(context);
                await _updateUserField(fieldType == 'email' ? 'email' : 'phoneNumber', value);
              },
              child: const Text('Save', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _launchEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'caloriemeter@gmail.com',
      queryParameters: {'subject': 'Report a problem'},
    );
    await launchUrl(emailLaunchUri);
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
      );

  Widget _listTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.black)),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _sectionTitle('YOUR CREDENTIALS'),
          _listTile('Email', email, () {
            _showEditDialog(
              title: 'Change Email',
              initialValue: email,
              fieldType: 'email',
              onSave: (value) => setState(() => email = value),
            );
          }),
          _listTile('Phone Number', phoneNumber, () {
            _showEditDialog(
              title: 'Change Phone Number',
              initialValue: phoneNumber,
              fieldType: 'phone',
              onSave: (value) => setState(() => phoneNumber = value),
            );
          }),
          _listTile('Password', '********', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
            );
          }),
          _sectionTitle('NOTIFICATION SETTINGS'),
          SwitchListTile(
            title: const Text('Allow Notifications'),
            activeColor: Colors.green,
            value: allowNotifications,
            onChanged: (val) async {
              setState(() => allowNotifications = val);
              await _updateNotificationPreference(val);
              if (val) {
                await scheduleMultipleHealthTips();
              } else {
                await cancelAllHealthTips();
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Report a Problem'),
            onTap: _launchEmailApp,
          ),
          ListTile(
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: _showDeleteDialog,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  Map<String, bool> preferences = {
    'Vegan': false,
    'Vegetarian': false,
    'Pescetarian': false,
    'Lactose intolerant': false,
    'Gluten intolerant': false,
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null && data['dietaryPreferences'] != null) {
        List<dynamic> savedPrefs = data['dietaryPreferences'];

        setState(() {
          preferences.updateAll((key, value) => savedPrefs.contains(key));
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error loading preferences: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _savePreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
        return;
      }

      final selectedPrefs = preferences.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'dietaryPreferences': selectedPrefs,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Preferences saved successfully!")));
    } catch (e) {
      print("Error saving preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save preferences")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dietary Preferences',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                ...preferences.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: preferences[key],
                    activeColor: Colors.green, // ✅ set active (checked) color to green
                    onChanged: (bool? value) {
                      setState(() {
                        preferences[key] = value!;
                      });
                    },
                  );
                }).toList(),
                SizedBox(height: 24), // spacing after checkboxes
                Center(
                  child: ElevatedButton(
                    onPressed: _savePreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Save Preferences",
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Lora',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24), // optional spacing below button
              ],
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Preferences(),
  ));
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllergiesScreen extends StatefulWidget {
  @override
  _AllergiesScreenState createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  Map<String, bool> allergies = {
    'Allergic to Milk': false,
    'Allergic to Eggs': false,
    'Allergic to Peanuts': false,
    'Allergic to Wheat': false,
    'Allergic to Fish': false,
    'Allergic to Chicken': false,
    'Allergic to Beef': false,
    'Allergic to Mutton': false,
    'Allergic to Lentils': false,
    'Allergic to Mustard': false,
    'Allergic to Soy': false,
    'Allergic to Tomatoes': false,
    'Allergic to Garlic': false,
    'Allergic to Onion': false,
    'Allergic to Spices': false,
  };

  final TextEditingController _customAllergyController = TextEditingController();
  List<String> customAllergies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _customAllergyController.text = "Allergic to ";
    _customAllergyController.addListener(() {
      final prefix = "Allergic to ";
      if (!_customAllergyController.text.startsWith(prefix)) {
        _customAllergyController.text = prefix;
        _customAllergyController.selection = TextSelection.fromPosition(
          TextPosition(offset: _customAllergyController.text.length),
        );
      }
    });
    _loadAllergies();
  }


  Future<void> _loadAllergies() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null && data['allergies'] != null) {
        List<dynamic> savedPrefs = data['allergies'];

        setState(() {
          allergies.updateAll((key, value) => savedPrefs.contains(key));
          customAllergies = savedPrefs
              .where((item) => !allergies.containsKey(item))
              .cast<String>()
              .toList();
          isLoading = false;
        });

      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error loading allergies: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveAllergies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
      return;
    }

    final rawInput = _customAllergyController.text.trim();
    String customInput = rawInput;

// Only add custom allergy if something meaningful is entered
    if (customInput.isNotEmpty && customInput.toLowerCase() != "allergic to") {
      if (!customInput.toLowerCase().startsWith("allergic to")) {
        customInput = "Allergic to $customInput";
      }

      if (!customAllergies.contains(customInput)) {
        customAllergies.add(customInput);
      }

      _customAllergyController.clear();
    }


    final selectedPrefs = [
      ...allergies.entries.where((entry) => entry.value).map((entry) => entry.key),
      ...customAllergies,
    ];

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'allergies': selectedPrefs,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Allergies saved successfully!")));
      setState(() {}); 
    } catch (e) {
      print("Error saving Allergies: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save Allergies!")));
    }
  }

  void _addCustomAllergy() {
    final text = _customAllergyController.text.trim();
    if (text.isNotEmpty) {
      final formatted = 'Allergic to $text';

      if (!allergies.containsKey(formatted) && !customAllergies.contains(formatted)) {
        setState(() {
          customAllergies.add(formatted);
          _customAllergyController.clear();
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Set Allergies', style: TextStyle(color: Colors.black)),
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
          : Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ...allergies.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    activeColor: Colors.green,
                    value: allergies[key],
                    onChanged: (bool? value) {
                      setState(() {
                        allergies[key] = value!;
                      });
                    },
                  );
                }).toList(),
                SizedBox(height: 20),
                TextField(
                  controller: _customAllergyController,
                  decoration: InputDecoration(
                    labelText: "Add Custom Allergy",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                SizedBox(height: 10),
                if (customAllergies.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Custom Allergies:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...customAllergies.map((allergy) => ListTile(
                        title: Text(allergy),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) return;

                            setState(() {
                              customAllergies.remove(allergy);
                            });

                            try {
                              final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
                              final doc = await docRef.get();
                              if (doc.exists && doc.data()!.containsKey('allergies')) {
                                List<dynamic> currentAllergies = List.from(doc['allergies']);
                                currentAllergies.remove(allergy);
                                await docRef.update({'allergies': currentAllergies});
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Custom allergy deleted successfully")),
                              );
                            } catch (e) {
                              print("Error deleting allergy from Firebase: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to delete allergy from database")),
                              );
                            }
                          },
                        ),
                      )),
                    ],
                  ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _saveAllergies,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: Text(
                "Save Allergies",
                style: TextStyle(fontSize: 19, fontFamily: 'Lora', color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

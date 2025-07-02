import 'package:calorieMeter/activity_level.dart';
import 'package:flutter/material.dart';
import 'package:calorieMeter/goal_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  String name = "";
  String height = "";
  String weight = "";
  String gender = "";
  String goal = "";
  String activityLevel = "";
  int dailyCalorieGoal = 0;
  int consumedToday = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        height = data['height']?.toString() ?? '';
        weight = data['weight']?.toString() ?? '';
        gender = data['gender'] ?? '';
        goal = (data['goals'] is List && data['goals'].isNotEmpty) ? data['goals'][0] : '';
        activityLevel = data['activityLevel'] ?? '';
        dailyCalorieGoal = data['dailyCalorieGoal'] ?? 0;
        consumedToday = data['consumedToday'] ?? 0;
        isLoading = false;
      });
    }
  }

  void _updateActivityLevel(String newLevel) {
    setState(() {
      activityLevel = newLevel;
    });
  }

  void _updateGoal(String newGoal) {
    setState(() {
      goal = newGoal;
    });
  }

  String _capitalizeEachWord(String input) {
    return input.split(" ").map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(" ");
  }

  void _editField(String title, String value, Function(String) onSave) {
    final controller = TextEditingController(
      text: title == "Name" ? value : value.replaceAll(RegExp(r'[^0-9.]'), ''),
    );

    String unit = value.contains("cm")
        ? "cm"
        : value.contains("ft")
            ? "ft/in"
            : value.contains("kg")
                ? "kg"
                : value.contains("lb")
                    ? "lb"
                    : "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Edit $title"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: title == "Name"
                        ? TextInputType.name
                        : const TextInputType.numberWithOptions(decimal: true),
                    maxLength: title == "Name" ? 30 : null,
                    decoration: InputDecoration(
                      hintText: "Enter $title",
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  if (title == "Height")
                    TextButton(
                      onPressed: () {
                        setState(() {
                          unit = unit == "cm" ? "ft/in" : "cm";
                        });
                      },
                      child: Text("Switch to ${unit == "cm" ? "ft/in" : "cm"}",
                          style: const TextStyle(color: Colors.green)),
                    ),
                  if (title == "Weight")
                    TextButton(
                      onPressed: () {
                        setState(() {
                          unit = unit == "kg" ? "lb" : "kg";
                        });
                      },
                      child: Text("Switch to ${unit == "kg" ? "lb" : "kg"}",
                          style: const TextStyle(color: Colors.green)),
                    ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              String input = controller.text.trim();

              if (title == "Name") {
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(input)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Only alphabets are allowed in Name.")),
                  );
                  return;
                }
                input = _capitalizeEachWord(input);
              } else if (input.isEmpty || double.tryParse(input) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a valid $title.")),
                );
                return;
              }

              String formattedValue = title == "Height" && unit == "ft/in"
                  ? "$input ft"
                  : title == "Name"
                      ? input
                      : "$input $unit";

              if (uid != null) {
                await FirebaseFirestore.instance.collection('users').doc(uid).update({
                  title.toLowerCase(): formattedValue,
                });
              }

              onSave(formattedValue);
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _editGender() {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.grey,
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                return states.contains(WidgetState.selected)
                    ? Colors.green
                    : Colors.grey;
              },
            ),
          ),
          dialogTheme: const DialogTheme(backgroundColor: Colors.white),
        ),
        child: AlertDialog(
          title: const Text("Select Gender"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text("Female"),
                value: "Female",
                groupValue: gender,
                onChanged: (value) {
                  setState(() => gender = value.toString());
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Male"),
                value: "Male",
                groupValue: gender,
                onChanged: (value) {
                  setState(() => gender = value.toString());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      double parsedWeight = double.tryParse(weight.split(" ").first) ?? 60;

      double baseCalorie = parsedWeight * 22;
      double activityMultiplier = {
        "Sedentary": 1.2,
        "Lightly Active": 1.375,
        "Moderately Active": 1.55,
        "Very Active": 1.725,
        "Extra Active": 1.9
      }[activityLevel] ?? 1.2;

      double adjustedCalorie = baseCalorie * activityMultiplier;

      if (goal == "Weight Loss") adjustedCalorie -= 500;
      else if (goal == "Weight Gain") adjustedCalorie += 500;

      int updatedCalorieGoal = adjustedCalorie.round();

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'height': height,
        'weight': weight,
        'gender': gender,
        'goal': goal,
        'activityLevel': activityLevel,
        'dailyCalorieGoal': updatedCalorieGoal,
        'consumedToday': 0,
        'date': DateTime.now().toIso8601String().split("T")[0],
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Set Your Profile', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("YOUR GOAL", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ListTile(
                  title: const Text("Goal", style: TextStyle(color: Colors.black, fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Text(goal, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 13),
                    ],
                  ),
                  onTap: () async {
                    final selectedGoal = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoalPage(currentGoal: goal)),
                    );
                    if (selectedGoal != null) _updateGoal(selectedGoal);
                  },
                ),
                const SizedBox(height: 8),
                const Text("DETAILS", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ListTile(
                  title: const Text("Name"),
                  trailing: Text(name, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  onTap: () => _editField("Name", name, (value) => setState(() => name = value)),
                ),
                ListTile(
                  title: const Text("Height"),
                  trailing: Text(height, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  onTap: () => _editField("Height", height, (value) => setState(() => height = value)),
                ),
                ListTile(
                  title: const Text("Weight"),
                  trailing: Text(weight, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  onTap: () => _editField("Weight", weight, (value) => setState(() => weight = value)),
                ),
                ListTile(
                  title: const Text("Gender"),
                  trailing: Text(gender, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  onTap: _editGender,
                ),
                ListTile(
                  title: const Text("Activity Level"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Text(activityLevel,
                            style: const TextStyle(color: Colors.black54, fontSize: 16)),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 13),
                    ],
                  ),
                  onTap: () async {
                    final selectedLevel = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityLevel(currentLevel: activityLevel)),
                    );
                    if (selectedLevel != null) _updateActivityLevel(selectedLevel);
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
                      shape: RoundedRectangleBorder(),
                    ),
                    child: const Text(
                      "Save Profile",
                      style: TextStyle(fontSize: 19, fontFamily: 'Lora', color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

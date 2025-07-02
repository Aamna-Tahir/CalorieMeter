// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';

class GoalPage extends StatefulWidget {
  final String currentGoal;
  const GoalPage({required this.currentGoal});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String? selectedGoal;

  @override
  void initState() {
    super.initState();
    selectedGoal = widget.currentGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
         'Goal',
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

      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(8.0), // Optional: to add some spacing
    child: Column(
      children: [
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Lose Weight"),
          subtitle: const Text("Manage your weight by eating smarter"),
          value: "Lose Weight",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Maintain Weight"),
          subtitle: const Text("Optimize your well-being"),
          value: "Maintain Weight",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Gain Weight"),
          subtitle: const Text("Build strength with high-protein food"),
          value: "Gain Weight",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Gain Muscle"),
          subtitle: const Text("Increase strength with protein-rich meals"),
          value: "Gain Muscle",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Modify My Diet"),
          subtitle: const Text("Adjust nutrition to meet your health goals"),
          value: "Modify My Diet",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Plan Meals"),
          subtitle: const Text("Organize your diet with smart meal choices"),
          value: "Plan Meals",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Manage Stress"),
          subtitle: const Text("Relax and recharge with healthy habits"),
          value: "Manage Stress",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.green, 
          title: const Text("Stay Active"),
          subtitle: const Text("Boost energy with regular physical activity"),
          value: "Stay Active",
          groupValue: selectedGoal,
          onChanged: (value) {
            setState(() {
              selectedGoal = value as String;
            });
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          // onPressed: () => showTestNotificationNow(),
          onPressed: () {
            
            Navigator.pop(context, selectedGoal);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text("Save", style: TextStyle(fontSize: 16)),

        ),
      ],
    ),
  ),
),

    
    );
  }
}

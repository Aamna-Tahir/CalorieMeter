// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class GoalPage extends StatefulWidget {
  final String currentGoal;
  GoalPage({required this.currentGoal});

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

      body: Column(
        children: [
          RadioListTile(
            title: Text("Lose Weight"),
            subtitle: Text("Manage your weight by eating smarter"),
            value: "Lose Weight",
            groupValue: selectedGoal,
            onChanged: (value) {
              setState(() {
                selectedGoal = value as String;
              });
            },
          ),
          RadioListTile(
            title: Text("Maintain Weight"),
            subtitle: Text("Optimize your well-being"),
            value: "Maintain Weight",
            groupValue: selectedGoal,
            onChanged: (value) {
              setState(() {
                selectedGoal = value as String;
              });
            },
          ),
          RadioListTile(
            title: Text("Gain Weight"),
            subtitle: Text("Build strength with high-protein food"),
            value: "Gain Weight",
            groupValue: selectedGoal,
            onChanged: (value) {
              setState(() {
                selectedGoal = value as String;
              });
            },
          ),
           SizedBox(
            height: 30, 
          ),
           
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedGoal);
            },
           style: ElevatedButton.styleFrom(
           backgroundColor: Colors.green, // Green button color
           foregroundColor: Colors.white, // White text color
           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Bigger button size
           shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(5), // Rectangle shape with slight rounding
         ),
       ),
           child: Text("Save", style: TextStyle(fontSize: 16)),
       ),         
        
        ],
      ),
    );
  }
}

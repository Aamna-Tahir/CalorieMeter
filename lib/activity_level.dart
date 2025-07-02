// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/material.dart';

class ActivityLevel extends StatefulWidget {
  final String currentLevel;
  const ActivityLevel({required this.currentLevel});

  @override
  _ActivityLevelState createState() => _ActivityLevelState();
}

class _ActivityLevelState extends State<ActivityLevel> {
  String? selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
     appBar: AppBar(
        title: const Text(
         'Activity Level',
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
            activeColor: Colors.green, 
            title: Text("Not Very Active"),
            subtitle: Text("Little to no daily activity"),
            value: "Not Very Active",
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value as String;
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.green, 
            title: Text("Lightly Active"),
            subtitle: Text("Light daily activity"),
            value: "Lightly Active",
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value as String;
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.green, 
            title: Text("Active"),
            subtitle: Text("Physically active throughout the day"),
            value: "Active",
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value as String;
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.green, 
            title: Text("Very Active"),
            subtitle: Text("Physically demanding daily activity"),
            value: "Very Active",
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value as String;
              });
            },
          ),
          SizedBox(
            height: 30, 
          ),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedLevel);
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

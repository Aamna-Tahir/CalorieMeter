// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:calorieMeter/activity_level.dart';
import 'package:flutter/material.dart';
import 'package:calorieMeter/goal_page.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SetProfile(),
  ));
}

class SetProfile extends StatefulWidget {
  @override
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  String name = "Aamna";
  String height = "160 cm";
  String weight = "55 kg";
  String gender = "Female";
  String goal = "Maintain weight";
  String activityLevel = "Moderate";

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
  void _editField(String title, String value, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: title == "Height" || title == "Weight"
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: "Enter $title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editGender() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Gender"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text("Female"),
              value: "Female",
              groupValue: gender,
              onChanged: (value) {
                setState(() => gender = value.toString());
                Navigator.pop(context);
                
              },
            ),
            RadioListTile(
              title: Text("Male"),
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
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
         'Set Your Profile',
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

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("YOUR GOAL", style: TextStyle(fontSize: 16, color: Colors.black54)),
          ListTile(
            title: Text("Goal",style: TextStyle(color: Colors.black,fontSize: 16)),
            trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 3), // Adjust right padding
                child: Text(goal, style: TextStyle(color: Colors.black54,fontSize: 16)),
                ),
              Icon(Icons.arrow_forward_ios, size: 13),
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
          SizedBox(height: 8),
          Text("DETAILS", style: TextStyle(fontSize: 16, color: Colors.black54)),
          ListTile(
            title: Text("Name"),
            trailing: Text(name, style: TextStyle(color: Colors.black54, fontSize: 16)),
            onTap: () => _editField("Name", name, (value) => setState(() => name = value)),
          ),
          ListTile(
            title: Text("Height"),
            trailing: Text(height, style: TextStyle(color: Colors.black54, fontSize: 16)),
            onTap: () => _editField("Height", height, (value) => setState(() => height = value)),
          ),
          ListTile(
            title: Text("Weight"),
            trailing: Text(weight, style: TextStyle(color: Colors.black54, fontSize: 16)),
            onTap: () => _editField("Weight", weight, (value) => setState(() => weight = value)),
          ),
          ListTile(
            title: Text("Gender"),
            trailing: Text(gender, style: TextStyle(color: Colors.black54, fontSize: 16)),
            onTap: _editGender,
          ),
          ListTile(
            title: Text("Activity Level"),
            trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 3), // Adjust right padding
                child: Text(activityLevel, style: TextStyle(color: Colors.black54,fontSize: 16)),
                ),
              Icon(Icons.arrow_forward_ios, size: 13),
            ],
          ),
          onTap: () async {
              final selectedLevel = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActivityLevel(currentLevel: activityLevel)),
              );
              if (selectedLevel != null) _updateActivityLevel(selectedLevel);
           },
        ),

        ],
      ),
    );
  }
}

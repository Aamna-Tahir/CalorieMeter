import 'package:flutter/material.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  Map<String, bool> preferences = {
    'Vegan': false,
    'Vegetarian': false,
    'Pescetarian': false,
    'Allergic to nuts': false,
    'Allergic to fish': false,
    'Allergic to shellfish': false,
    'Allergic to egg': false,
    'Allergic to milk': false,
    'Lactose intolerant': false,
    'Gluten intolerant': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: ListView(
        children: preferences.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: preferences[key],
            onChanged: (bool? value) {
              setState(() {
                preferences[key] = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Preferences(),
  ));
}
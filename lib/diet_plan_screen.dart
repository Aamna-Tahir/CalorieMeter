import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DietPlanScreen extends StatefulWidget {
  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  Map<String, dynamic>? dietPlan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDietPlan();
  }

  Future<void> fetchDietPlan() async {
    final url = Uri.parse(
        'http://192.168.18.132:3000/api/generate_diet'); // Replace with your backend API
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    final profileData = {
      "age": data?['age'],
      "gender": data?['gender'],
      "weight": data?['weight'],
      "height": data?['height'],
      "activityLevel": data?['activityLevel'],
      "goal": data?['goal'],
      "dietPreference": data?['dietPreference'],
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profileData),
      );
       if (!mounted) return; 
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dietPlan = data['diet'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load diet plan');
      }
    } catch (e) {
      print('Error: $e');
      if (!mounted) return; 
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dietPlan == null
          ? Center(child: Text("Failed to load diet plan."))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _mealCard("Breakfast", List<String>.from(dietPlan!['breakfast'])),
              _mealCard("Lunch", List<String>.from(dietPlan!['lunch'])),
              _mealCard("Dinner", List<String>.from(dietPlan!['dinner'])),
              SizedBox(height: 2),
              _waterIntakeSection(dietPlan!['water_goal']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealCard(String mealType, List<String> options) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mealType,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          for (var option in options)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(option, style: TextStyle(fontSize: 16)),
            ),
        ],
      ),
    );
  }

  Widget _waterIntakeSection(String goalText) {
    final glassCount = int.tryParse(
        RegExp(r'\d+').firstMatch(goalText)?.group(0) ?? '6') ?? 6;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Water Intake",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Goal: $goalText",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              glassCount,
                  (index) => Icon(Icons.local_drink, size: 40, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

}

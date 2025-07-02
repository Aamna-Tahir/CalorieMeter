import 'package:calorieMeter/health_habits_screen.dart';
import 'package:flutter/material.dart';
import 'nameinputscreen.dart';
import 'onboarding_data_service.dart';

class GoalsTutorialScreen extends StatefulWidget {
  const GoalsTutorialScreen({super.key});


  @override
  _GoalsTutorialScreenState createState() => _GoalsTutorialScreenState();
}

class _GoalsTutorialScreenState extends State<GoalsTutorialScreen> {
  final List<String> goals = [
    "Lose Weight",
    "Maintain Weight",
    "Gain Weight",
    "Gain Muscle",
    "Modify My Diet",
    "Plan Meals",
    "Manage Stress",
    "Stay Active",
  ];

  final Set<String> selectedGoals = {};

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        if (selectedGoals.length < 3) {
          selectedGoals.add(goal);
        }
      }
    });
  }

  Widget _buildGoalTile(String goal) {
    final isSelected = selectedGoals.contains(goal);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.green, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: ListTile(
        title: Text(goal, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => _toggleGoal(goal),
          activeColor: Colors.green,
        ),
        onTap: () => _toggleGoal(goal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Goals", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Let’s start with goals.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text("Select up to 3 that are important to you, including one weight goal.",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: goals.map(_buildGoalTile).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.green),
              onPressed: () {
                 Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => NameInputScreen()),
           );
              },
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: selectedGoals.isNotEmpty
                  ? () {
                      OnboardingDataService().selectedGoals = selectedGoals.toList();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HealthHabitsSelectionScreen()),
                      );
                    }
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedGoals.isNotEmpty
                      ? Colors.green
                      : Colors.green.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

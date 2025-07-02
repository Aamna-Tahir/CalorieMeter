import 'package:calorieMeter/user_activity_level.dart';
import 'package:flutter/material.dart';
import 'goalstutorialscreen.dart';
import 'onboarding_data_service.dart';

class HealthHabitsSelectionScreen extends StatefulWidget {
  const HealthHabitsSelectionScreen({super.key});

  @override
  _HealthHabitsSelectionScreenState createState() => _HealthHabitsSelectionScreenState();
}

class _HealthHabitsSelectionScreenState extends State<HealthHabitsSelectionScreen> {
  final List<String> recommendedHabits = [
    "Eat more protein", "Plan more meals", "Meal prep and cook", "Eat more fiber",
    "Move more", "Workout more"
  ];

  final List<String> moreHabits = [
    "Track nutrients", "Track calories", "Track macros", "Eat mindfully",
    "Eat a balanced diet", "Eat whole foods", "Eat more vegetables", "Eat more fruit",
    "Drink more water", "Prioritize sleep", "Something else", "I'm not sure"
  ];

  final Set<String> selectedHabits = {};

  void toggleHabit(String habit) {
    setState(() {
      if (selectedHabits.contains(habit)) {
        selectedHabits.remove(habit);
      } else {
        selectedHabits.add(habit);
      }
    });
  }

  Widget buildChip(String habit) {
    final isSelected = selectedHabits.contains(habit);
    return ChoiceChip(
      label: Text(habit),
      selected: isSelected,
      showCheckmark: false,
       backgroundColor: Colors.grey[100],
      selectedColor: Colors.green.withOpacity(0.1),
      side: BorderSide(
        color: isSelected ? Colors.green : Colors.grey.shade300,
      ),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: (_) => toggleHabit(habit),
    );
  }

  Widget buildSection(String title, List<String> habits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: habits.map(buildChip).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Goals", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Which health habits are most important to you?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSection("Recommended for you", recommendedHabits),
                      buildSection("More healthy habits", moreHabits),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  MaterialPageRoute(builder: (context) => GoalsTutorialScreen()),
                );
              },
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: selectedHabits.isNotEmpty
                    ? () {
                       OnboardingDataService().selectedHabits = selectedHabits.toList();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UserActivityLevel()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedHabits.isNotEmpty
                      ? Colors.green
                      : Colors.green.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

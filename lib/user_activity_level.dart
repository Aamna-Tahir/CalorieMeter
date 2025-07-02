import 'package:flutter/material.dart';
import 'health_habits_screen.dart';
import 'user_info.dart';
import 'onboarding_data_service.dart';

class UserActivityLevel extends StatefulWidget {
  const UserActivityLevel({super.key});

  @override
  _UserActivityLevelState createState() => _UserActivityLevelState();
}

class _UserActivityLevelState extends State<UserActivityLevel> {
  String? _selectedActivity;

  final List<Map<String, String>> _activityLevels = [
    {
      "title": "Not Very Active",
      "subtitle": "Spend most of the day sitting (e.g., bankteller, desk job)."
    },
    {
      "title": "Lightly Active",
      "subtitle": "Spend a good part of the day on your feet (e.g., teacher, salesperson)."
    },
    {
      "title": "Active",
      "subtitle": "Spend a good part of the day doing some physical activity (e.g., food server, postal carrier)."
    },
    {
      "title": "Very Active",
      "subtitle": "Spend a good part of the day doing heavy physical activity (e.g., bike messenger, carpenter)."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and progress bar only
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                "Activity Level",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < 6 ? 4 : 0), 
                      decoration: BoxDecoration(
                        color: index < 5 ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Question
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "What is your baseline activity level?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Activity options
            Expanded(
              child: ListView.builder(
                itemCount: _activityLevels.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final activity = _activityLevels[index];
                  return Card(
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      activeColor: Colors.green,
                      title: Text(activity['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(activity['subtitle']!),
                      value: activity['title']!,
                      groupValue: _selectedActivity,
                      onChanged: (value) {
                        setState(() {
                          _selectedActivity = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom nav with back icon and next button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.green),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthHabitsSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedActivity == null
                          ? null
                          : () {
                              OnboardingDataService().activityLevel = _selectedActivity!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserInformation()),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.green.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

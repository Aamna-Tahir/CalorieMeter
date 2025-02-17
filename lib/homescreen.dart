import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Calorie Goal Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 10.0,
                  percent: 0.3,
                  center: Text("30%"),
                  progressColor: Colors.green,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _calorieInfo(Icons.track_changes, "Calorie Goal", "1896"),
                    _calorieInfo(Icons.local_fire_department, "Burned", "896"),
                    _calorieInfo(Icons.restaurant, "Consumed", "614"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Nutrients Section
          _sectionContainer(
            "Nutrients",
            [
              _nutrientIndicator("Proteins", 70, Colors.orange),
              _nutrientIndicator("Carbs", 70, Colors.teal),
              _nutrientIndicator("Fats", 30, Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          // Exercise Section
          _exerciseSection(),
        ],
      ),
    );
  }

  Widget _calorieInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.red),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _nutrientIndicator(String label, int value, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30.0,
          lineWidth: 5.0,
          percent: value / 100,
          center: Text("${value}g"),
          progressColor: color,
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _sectionContainer(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow.shade200, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _exerciseSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow.shade200, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Exercise", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _exerciseInfo(Icons.directions_run, "Cardio", "30 mins"),
              _exerciseInfo(Icons.self_improvement, "Aerobic", "1 hour"),

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _dayIndicator("M"), _dayIndicator("T"), _dayIndicator("W"), _dayIndicator("T"), _dayIndicator("F"), _dayIndicator("S"), _dayIndicator("S")
            ],
          )
        ],
      ),
    );
  }

  Widget _exerciseInfo(IconData icon, String label, String duration) {
    return Row(
      children: [
        Icon(icon, size: 40),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            Text(duration, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
Widget _dayIndicator(String day) {
  return CircleAvatar(
    backgroundColor: Colors.green,
    child: Text(day, style: TextStyle(color: Colors.white)),
  );
}

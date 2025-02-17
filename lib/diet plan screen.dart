import 'package:flutter/material.dart';

class DietPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _mealCard("Breakfast", [
                "Option 1: Greek yogurt with fresh berries and a sprinkle of chia seeds.",
                "Option 2: 2 boiled eggs, 1 slice of whole-grain toast, and a handful of spinach."
              ]),
              _mealCard("Lunch", [
                "Option 1: Grilled salmon, mixed greens with olive oil dressing.",
                "Option 2: Lentil soup with a side of cucumber and tomato salad."
              ]),
              _mealCard("Dinner", [
                "Option 1: Baked chicken, roasted sprouts, mashed avocado.",
                "Option 2: Turkey patty, sautéed spinach, roasted carrots."
              ]),
              SizedBox(height: 16),
              _waterIntakeSection(),
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
        gradient: LinearGradient(
          colors: [Colors.lightGreenAccent, Colors.greenAccent.shade100],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mealType, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          for (var option in options) Text(option, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _waterIntakeSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade100],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Water Intake", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Goal: 6 glass", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) => Icon(Icons.local_drink, size: 40, color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

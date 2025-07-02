import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> logs = [];
  int? selectedIndex;
  Map<String, dynamic>? selectedLog;
  List<Map<String, dynamic>> allLogs = [];
  int netCalories = 0;

  List<FlSpot> calorieSpots = [];
  List<String> dateLabels = [];
  bool isGraphLoading = true;

  String option1 = "";
  String option2 = "";
  List<String> exercises = [];


  bool isDataLoading = true;
  bool isExerciseLoading = true;
  bool isLoading = true;

  List<FlSpot> graphData = [];

  Future<void> fetchGraphData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dailyLogs')
        .orderBy('date', descending: false)
        .limit(7)
        .get();

    final spots = snapshot.docs.asMap().entries.map((entry) {
      int index = entry.key;
      final doc = entry.value;
      double netCalories = (doc['netCalories'] ?? 0).toDouble();
      return FlSpot(index.toDouble(), netCalories);
    }).toList();
    if (!mounted) return;
    setState(() {
      graphData = spots;
    });
  }

  Future<void> fetchExerciseRecommendations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data == null) return;

      final profileData = {
        "age": data['age'],
        "gender": data['gender'],
        "weight": data['weight'],
        "height": data['height'],
        "activityLevel": data['activityLevel'],
        "goal": data['goal'],
      };

      final response = await http.post(
        Uri.parse('http://192.168.0.106:3000/api/generate_exercise'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final fetchedExercises = responseData['exercise']['exercise'];

        if (fetchedExercises != null && fetchedExercises is List) {
          if (!mounted) return;
          setState(() {
            exercises = List<String>.from(fetchedExercises);
            option1 = exercises.length > 0
                ? exercises[0].replaceFirst('Option 1: ', '')
                : 'No Option 1';
            option2 = exercises.length > 1
                ? exercises[1].replaceFirst('Option 2: ', '')
                : 'No Option 2';
            isExerciseLoading = false;
            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          option1 = "Failed to load";
          option2 = "Failed to load";
          isExerciseLoading = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      if (!mounted) return;
      setState(() {
        option1 = "Something went wrong";
        option2 = "Something went wrong";
        isLoading = false;
      });
    }

  }


  Widget _exerciseCard(String title, String recommendation) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.green.shade200],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports_gymnastics, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(recommendation, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  int calorieGoal = 0;
  int consumed = 0;
  int burned = 0;

  Future<void> fetchCalorieGraphData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final logsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dailyLogs')
        .orderBy('date', descending: false)
        .limit(7);

    final snapshot = await logsRef.get();
    final logs = snapshot.docs;

    calorieSpots = [];
    dateLabels = [];
    allLogs = [];

    logs.sort((a, b) {
      DateTime dateA = (a['date'] as Timestamp).toDate();
      DateTime dateB = (b['date'] as Timestamp).toDate();
      return dateA.compareTo(dateB);
    });

    for (int i = 0; i < logs.length; i++) {
      final log = logs[i].data();
      final date = (log['date'] as Timestamp).toDate();
      final netCalories = log['netCalories'];

      if (netCalories != null) {
        calorieSpots.add(FlSpot(i.toDouble(), netCalories.toDouble()));
        dateLabels.add("${date.day}/${date.month}");
        allLogs.add(log);
      }
    }
    if (!mounted) return;
    setState(() {
      isGraphLoading = false;
    });
  }



  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
    fetchExerciseRecommendations();
    fetchGraphData();
    fetchCalorieGraphData();

  }
  Widget calorieProgressGraph() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.shade300)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Weekly Calorie Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: calorieSpots.isEmpty
                      ? 100
                      : calorieSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 100,
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                      if (!event.isInterestedForInteractions || response == null || response.lineBarSpots == null) return;

                      final spot = response.lineBarSpots!.first;
                      int index = spot.x.toInt();
                      if (!mounted) return;
                      if (index >= 0 && index < allLogs.length) {
                        setState(() {
                          selectedIndex = index;
                          selectedLog = allLogs[index];
                        });
                      }
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: calorieSpots,
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          return index >= 0 && index < dateLabels.length
                              ? Text(dateLabels[index], style: TextStyle(fontSize: 10))
                              : Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                )

            ),
          ),
          if (selectedLog != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade100, Colors.green.shade200],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.green.shade700, size: 26),
                      SizedBox(width: 10),
                      Text("Log for ${dateLabels[selectedIndex!]}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 14),
                  _logDetailRow("🎯 Goal", selectedLog!['goal']),
                  _logDetailRow("🔥 Burned", selectedLog!['burned']),
                  _logDetailRow("🍽️ Consumed", selectedLog!['consumed']),
                  _logDetailRow("⚖️ Net Calories", selectedLog!['netCalories']),
                ],
              ),
            ),

          ],



        ],
      ),
    );
  }

  Widget _logDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(width: 12),
          Text(value?.toString() ?? '-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }







  Future<void> fetchDataFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();
      final data = doc.data();

      if (data != null) {
        Map<String, dynamic> log = data['exerciseLog'] ?? {};
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);

        // 🔄 Compare last updated date
        Timestamp? lastUpdatedTimestamp = data['lastUpdated'];
        DateTime? lastUpdatedDate = lastUpdatedTimestamp?.toDate();
        DateTime lastDate = lastUpdatedDate != null
            ? DateTime(lastUpdatedDate.year, lastUpdatedDate.month, lastUpdatedDate.day)
            : DateTime(2000);

        if (today.isAfter(lastDate)) {
          // 🔁 New Day: Reset
          await docRef.update({
            'consumedToday': 0,
            'burnedToday': 0,
            'lastUpdated': Timestamp.fromDate(now),
          });

          consumed = 0;
          burned = 0;

          print("🔥 Calories reset for new day");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ New day! Calories reset.")),
          );
        } else {
          // ➕ Load existing
          consumed = data['consumedToday'] ?? 0;
          burned = data['burnedToday'] ?? 0;
        }

        // 🎯 Goal from user data
        calorieGoal = data['dailyCalorieGoal'] ?? 0;

        // 📝 Save to today's log with calculated net
        final todayKey = DateTime.now().toIso8601String().substring(0, 10);
        final todayNetCalories = (consumed - burned).clamp(0, double.infinity).toInt();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('dailyLogs')
            .doc(todayKey)
            .set({
          'date': Timestamp.fromDate(DateTime.now()),
          'consumed': consumed,
          'burned': burned,
          'goal': calorieGoal,
          'netCalories': todayNetCalories,
        }, SetOptions(merge: true));

        // ✅ Fetch netCalories from today’s log
        final todayDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('dailyLogs')
            .doc(todayKey)
            .get();

        int net = 0;
        if (todayDoc.exists) {
          final todayData = todayDoc.data();
          net = todayData?['netCalories'] ?? 0;
        }
        if (!mounted) return;
        setState(() {
          netCalories = net; 
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    int netCalories = consumed - burned;
    if (netCalories < 0) netCalories = 0; // prevent negative values

    double percent = calorieGoal > 0 ? netCalories / calorieGoal : 0.0;
    if (percent > 1) percent = 1;
    _calorieInfo(Icons.compare_arrows, "Net Calories", "${consumed - burned}");

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                  percent: percent,
                  center: Text("${(percent * 100).toInt()}%"),
                  progressColor: Colors.green,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _calorieInfo(Icons.track_changes, "Calorie Goal", "$calorieGoal"),
                    _calorieInfo(Icons.local_fire_department, "Burned", "$burned"),
                    _calorieInfo(Icons.restaurant, "Consumed", "$consumed"),
                    _calorieInfo(Icons.compare_arrows, "Net Calories", "$netCalories")

            ],
                ),
              ],
            ),
          ),
          // SizedBox(height: 16),

          // // Nutrients Section
          // _sectionContainer(
          //   "Nutrients",
          //   [
          //     _nutrientIndicator("Proteins", 70, Colors.orange),
          //     _nutrientIndicator("Carbs", 70, Colors.teal),
          //     _nutrientIndicator("Fats", 30, Colors.grey),
          //   ],
          // ),
          SizedBox(height: 16),

          // Exercise Section
          _exerciseSection(),
          SizedBox(height: 16),
          if (graphData.isNotEmpty) calorieProgressGraph(),

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
            Text(title, style: TextStyle(fontSize: 16)),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _sectionContainer(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Exercise Recommendations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 12),
          isExerciseLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _exerciseCard("Option 1", option1.isNotEmpty ? option1 : "No exercise found"),
              SizedBox(height: 4),
              SizedBox(height: 12),
              _exerciseCard("Option 2", option2.isNotEmpty ? option2 : "No exercise found"),
              SizedBox(height: 4),
            ],
          ),
          SizedBox(height: 20),

          Text("Did the Exercise? Tap to Track", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => onExerciseTap("option1"),
                icon: Icon(Icons.check_circle, color: Colors.black),
                label: Text(
                  "Option 1",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () => onExerciseTap("option2"),
                icon: Icon(Icons.check_circle, color: Colors.black),
                label: Text(
                  "Option 2",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  elevation: 2,
                  shape: RoundedRectangleBorder (
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                ),
              ),
            ],
          ),
        ],), );
  }
  Future<void> updateBurnedCalories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'burnedToday': burned,
    });
  }
  int extractCalories(String text) {
    final regex = RegExp(r'(\d+)\s*cal', caseSensitive: false);
    final match = regex.firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 0;
    }
    return 0;
  }


  Future<void> onExerciseTap(String exerciseKey) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    int caloriesToAdd = 0;

    if (exerciseKey == "option1") {
      caloriesToAdd = extractCalories(option1);
    } else if (exerciseKey == "option2") {
      caloriesToAdd = extractCalories(option2);
    }
    if (!mounted) return;
    setState(() {
      burned += caloriesToAdd;
    });

    // 🔄 Update user's profile
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'burnedToday': burned,
    });

    // 📝 Also update dailyLogs
    final todayKey = DateTime.now().toIso8601String().substring(0, 10);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(todayKey)
        .set({
      'burned': burned,
      'netCalories': (consumed - burned).clamp(0, double.infinity).toInt(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$caloriesToAdd Calories burned today!'),
        duration: Duration(seconds: 2),
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

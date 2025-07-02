import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingDataService {
  // Singleton setup
  static final OnboardingDataService _instance = OnboardingDataService._internal();

  factory OnboardingDataService() => _instance;

  static OnboardingDataService get instance => _instance;

  OnboardingDataService._internal();

  // Data fields
  String? name;
  List<String> selectedGoals = [];
  List<String> selectedHabits = []; 
  String? activityLevel;
  String? gender;
  int? age;
  double? height;       
  double? weight;       
  double? goalWeight;
  List<String> allergies = [];
  List<String> dietaryPreferences = [];

  /// Save user data to Firestore
  Future<void> saveToFirestore(String uid) async {
    final userData = {
      'name': name,
      'goals': selectedGoals,
      'habits': selectedHabits,
      'activityLevel': activityLevel,
      'gender': gender,
      'age': age,
      'allergies': allergies,
      'height': height,
      'weight': weight,
      'goalWeight': goalWeight,
      'dietaryPreferences': dietaryPreferences,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userData, SetOptions(merge: true));
  }

  /// Reset onboarding data
  void reset() {
    name = null;
    selectedGoals.clear();
    selectedHabits.clear();
    activityLevel = null;
    gender = null;
    age = null;
    height = null;
    weight = null;
    goalWeight = null;
    allergies.clear();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';


class scan extends StatefulWidget {
  const scan({Key? key}) : super(key: key);

  @override
  State<scan> createState() => _scanState();
}

class _scanState extends State<scan> {
  final Map<String, List<String>> allergySynonyms = {
    'milk': ['milk', 'cheese', 'butter', 'cream', 'yogurt', 'ghee', 'paneer', 'dairy'],
    'eggs': ['egg', 'eggs', 'egg yolk', 'egg white', 'boiled egg', 'scrambled eggs'],
    'peanuts': ['peanut', 'peanuts', 'peanut butter', 'groundnut'],
    'wheat': ['wheat', 'flour', 'bread', 'chapati', 'naan', 'pasta', 'atta'],
    'fish': ['fish', 'salmon', 'tuna', 'cod', 'mackerel', 'sardine', 'anchovy'],
    'chicken': ['chicken', 'chicken meat', 'chicken cheese', 'chicken tikka'],
    'beef': ['beef', 'cow meat', 'beef steak', 'minced beef'],
    'mutton': ['mutton', 'goat meat', 'lamb', 'minced mutton'],
    'lentils': ['lentils', 'dal', 'masoor', 'moong', 'chana dal', 'urad dal'],
    'mustard': ['mustard', 'mustard seeds', 'mustard oil', 'sarson'],
    'soy': ['soy', 'soya', 'soybean', 'soy milk', 'soy sauce', 'tofu'],
    'tomatoes': ['tomato', 'tomatoes', 'ketchup', 'tomato paste'],
    'garlic': ['garlic', 'garlic paste', 'lehsun'],
    'onion': ['onion', 'onions', 'pyaaz'],
    'spices': ['spices', 'masala', 'red chili', 'turmeric', 'cumin', 'cloves', 'coriander'],
  };


  List<dynamic> userAllergies = [];
  File? _selectedImage;
  bool _isLoading = false;
  List<Map<String, dynamic>> foodItems = [];
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserAllergies();
  }

  Future<void> _fetchUserAllergies() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final savedAllergies = data['allergies'] ?? [];

      final Set<String> expandedAllergies = {};

      for (var allergy in savedAllergies) {
        final keyword = allergy.toString().toLowerCase().replaceAll("allergic to ", "").trim();
        expandedAllergies.add(keyword);
        if (allergySynonyms.containsKey(keyword)) {
          expandedAllergies.addAll(allergySynonyms[keyword]!);
        }
      }
      if (!mounted) return;
      setState(() {
        userAllergies = expandedAllergies.toList();
      });

      print("Expanded allergies: $userAllergies");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85, // Mild compression from ImagePicker
    );

    if (pickedFile != null) {
      final originalFile = File(pickedFile.path);

      // Try compressing the image
      Uint8List? compressedBytes;
      try {
        compressedBytes = await FlutterImageCompress.compressWithFile(
          originalFile.path,
          quality: 50,
          minWidth: 800,
          format: CompressFormat.jpeg,
        );
      } catch (e) {
        print("Image compression failed: $e");
      }

      
      final bytesToEncode = compressedBytes ?? await originalFile.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImage = originalFile; 
        foodItems.clear();
        totalCalories = 0;
      });

      final base64Image = "data:image/jpeg;base64,${base64Encode(bytesToEncode)}";
      await _sendToAPI(base64Image);
    }
  }
  Future<void> _sendToAPI(String base64Image) async {
    setState(() => _isLoading = true);

    final url = Uri.parse("http://192.168.18.132:3000/api/detect_food");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          if (!mounted) return;
          setState(() {
            foodItems = List<Map<String, dynamic>>.from(data["items"]);
            totalCalories = data["count"];
          });

          await _updateConsumedCalories(totalCalories);
          final foundAllergens = foodItems.expand((item) => item['ingredients']).where((ing) {
            final ingLower = ing.toString().toLowerCase().trim();
            return userAllergies.any((allergy) =>
            ingLower.contains(allergy) || allergy.contains(ingLower));
          }).toSet();


          if (foundAllergens.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("⚠ Allergens detected: ${foundAllergens.join(', ')}"),
                backgroundColor: Colors.red,
              ),
            );
          }

        }
      } else {
        print("API error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateConsumedCalories(int newCalories) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data()!;
      int consumed = data['consumedToday'] ?? 0;
      String storedDate = data['date'] ?? "";

      if (storedDate != today) {
        consumed = 0;
      }

      consumed += newCalories;

      await docRef.update({
        'consumedToday': consumed,
        'date': today,
      });

      final goal = data['dailyCalorieGoal'] ?? 2000;
      if (consumed > goal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠ You exceeded your calorie limit for today!')),
        );
      }
    }
  }

  Widget _buildReport() {
    if (_isLoading) {
      return const CircularProgressIndicator(color: Colors.lightGreen);
    }

    if (foodItems.isEmpty) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 25),
        const Text(
          "Analysis Report",
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        for (var item in foodItems)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.grey, blurRadius: 5),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: 'Lora',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Ingredients:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: List<Widget>.from(item['ingredients'].map((ing) {
                    final ingLower = ing.toString().toLowerCase().trim();
                    final isAllergic = userAllergies.any((allergy) =>
                    ingLower.contains(allergy) || allergy.contains(ingLower));
                    return Chip(
                      label: Text(
                        ing,
                        style: TextStyle(
                          color: isAllergic ? Colors.white : Colors.black,
                          fontWeight: isAllergic ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      backgroundColor: isAllergic ? Colors.red : Colors.lightGreen.shade100,
                    );
                  })),
                ),


              ],
            ),
          ),
        const SizedBox(height: 10),
        Text(
          "Total Calories: $totalCalories cal",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontFamily: 'Lora',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100, top: 40),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt, size: 28),
                label: const Text('Take a photo',
                    style: TextStyle(fontSize: 19, fontFamily: 'Lora')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 13),
                ),
              ),
              const SizedBox(height: 15),
              const Text('OR',
                  style: TextStyle(fontSize: 19, color: Colors.black54, fontFamily: 'Lora')),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo, size: 28),
                label: const Text('From Gallery',
                    style: TextStyle(fontSize: 19, fontFamily: 'Lora')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 13),
                ),
              ),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                height: 285,
                width: 290,
                fit: BoxFit.cover,
              )
                  : const Text('No image selected',
                  style: TextStyle(fontSize: 17, fontFamily: 'Lora')),
              _buildReport(),
            ],
          ),
        ),
      ),
    );
  }
}
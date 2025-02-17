import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class scan extends StatefulWidget {
  const scan({Key? key}) : super(key: key);

  @override
  State<scan> createState() => _scanState();
}

class _scanState extends State<scan> {
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                label: const Text('Take a photo', style: TextStyle(fontSize: 19, fontFamily: 'Lora')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 13),
                ),
              ),
              const SizedBox(height: 15),
              const Text('OR', style: TextStyle(fontSize: 19, color: Colors.black54, fontFamily: 'Lora')),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo, size: 28),
                label: const Text('From Gallery', style: TextStyle(fontSize: 19, fontFamily: 'Lora')),
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
                  : const Text('No image selected', style: TextStyle(fontSize: 17, fontFamily: 'Lora')),
            ],
          ),
        ),
      ),
    );
  }
}

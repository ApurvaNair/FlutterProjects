import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final TextEditingController _diseaseController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _navigateToResults() {
    if (_image == null) {
      _showError("Please upload a prescription image.");
      return;
    }

    if (_diseaseController.text.trim().isEmpty) {
      _showError("Please enter a disease or symptom.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          imagePath: _image!.path,
          diseaseInput: _diseaseController.text,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor's OCR Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _diseaseController,
              decoration: InputDecoration(
                labelText: 'Enter Disease or Symptom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(
                  _image == null ? 'Upload Prescription' : 'Image Selected'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToResults,
              child: const Text('Search Drugs'),
            ),
          ],
        ),
      ),
    );
  }
}

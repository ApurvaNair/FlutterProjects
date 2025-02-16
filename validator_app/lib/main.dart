import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(const PrescriptionApp());
}

class PrescriptionApp extends StatelessWidget {
  const PrescriptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prescription Validator',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PrescriptionScreen(),
    );
  }
}

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  File? _prescriptionImage;
  String _disease = '';
  String _extractedText = '';
  List<String> _validatedDrugs = [];
  bool _isLoading = false;

  final _diseaseController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _prescriptionImage = File(pickedFile.path);
          _extractedText = ''; // Reset extracted text when new image is picked.
        });
        await extractTextFromImage();
      }
    } catch (e) {
      showSnackBar('Error selecting image: ${e.toString()}');
    }
  }

  Future<void> extractTextFromImage() async {
    if (_prescriptionImage == null) return;

    try {
      setState(() => _isLoading = true);

      // Initialize the text recognition input and process the image.
      final inputImage = InputImage.fromFilePath(_prescriptionImage!.path);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
      });

      // Dispose the text recognizer.
      textRecognizer.close();
    } catch (e) {
      showSnackBar('Error extracting text: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> validateDrugs() async {
    if (_disease.isEmpty) {
      showSnackBar('Please enter a disease name.');
      return;
    }
    if (_extractedText.isEmpty) {
      showSnackBar('No text extracted from the prescription image.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final url = Uri.parse(
          'https://api.fda.gov/drug/label.json?search=indications_and_usage:"$_disease"');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        final validDrugs = results
            .map((result) => result['openfda']['brand_name'] ?? [])
            .expand((x) => x)
            .toList();

        final extractedDrugs = _extractedText.split(RegExp(r'\s+'));
        final matches =
            extractedDrugs.where((drug) => validDrugs.contains(drug)).toList();

        setState(() => _validatedDrugs = matches);
      } else {
        showSnackBar(
            'Failed to validate drugs. Status: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar('Error validating drugs: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Validator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _prescriptionImage == null
                    ? Center(
                        child: Text(
                          'Tap to upload prescription',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _prescriptionImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diseaseController,
              decoration: InputDecoration(
                labelText: 'Enter Disease',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => _disease = value,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : validateDrugs,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Validate Prescription'),
              ),
            ),
            const SizedBox(height: 16),
            if (_extractedText.isNotEmpty) ...[
              const Text(
                'Extracted Text:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _extractedText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_validatedDrugs.isNotEmpty) ...[
              const Text(
                'Validated Drugs:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _validatedDrugs
                      .map((drug) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(drug),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

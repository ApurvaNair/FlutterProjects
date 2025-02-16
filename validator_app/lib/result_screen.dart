import 'dart:io';

import 'package:flutter/material.dart';
import 'ocr_service.dart'; // For OCR text extraction
import 'fda_service.dart'; // For FDA drug validation

class ResultsScreen extends StatefulWidget {
  final String imagePath;
  final String diseaseInput; // Disease or symptom provided by the user

  const ResultsScreen({
    super.key,
    required this.imagePath,
    required this.diseaseInput,
  });

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Future<List<String>> _drugResults;

  @override
  void initState() {
    super.initState();
    _drugResults = _processImageAndSearchDrugs();
  }

  Future<List<String>> _processImageAndSearchDrugs() async {
    try {
      // Step 1: Extract text from the image using OCR (Handwritten OCR)
      final ocrText =
          await OCRService.recognizeTextFromImage(widget.imagePath as File);

      if (ocrText.trim().isEmpty) {
        throw Exception("No recognizable text found in the prescription.");
      }

      // Step 2: Validate extracted text against the disease input
      final disease = widget.diseaseInput.trim().toLowerCase();
      final drugs = await FDADrugService.searchDrugs(ocrText);

      // Step 3: Filter drugs related to the disease input
      final relatedDrugs = drugs.where((drug) {
        return drug.toLowerCase().contains(disease);
      }).toList();

      if (relatedDrugs.isEmpty) {
        throw Exception(
            "No drugs found related to the disease: ${widget.diseaseInput}");
      }

      return relatedDrugs;
    } catch (e) {
      throw Exception("Error processing prescription: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: FutureBuilder<List<String>>(
        future: _drugResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorScreen(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildNoResultsScreen();
          } else {
            return _buildResultsList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $errorMessage', textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _drugResults = _processImageAndSearchDrugs();
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsScreen() {
    return const Center(
      child: Text(
        'No matches found.',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultsList(List<String> drugs) {
    return ListView.builder(
      itemCount: drugs.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(drugs[index]),
          ),
        );
      },
    );
  }
}

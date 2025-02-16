import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'dart:async';

class OCRService {
  static Future<String> recognizeTextFromImage(File imageFile) async {
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String extractedText = recognizedText.text;
    await textRecognizer.close();

    return extractedText;
  }
}

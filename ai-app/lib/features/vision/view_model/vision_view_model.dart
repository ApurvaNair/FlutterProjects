import 'package:flutter/material.dart';
import '../../../core/services/audio_service.dart';
import '../model/vision_entry.dart';

class VisionViewModel extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  bool isRecording = false;
  VisionEntry? entry;

  Future<void> toggleRecording() async {
    if (!isRecording) {
      await _audioService.startRecording();
    } else {
      final path = await _audioService.stopRecording();
      entry = VisionEntry(
        audioPath: path,
        aiInsight: "AI Insight based on your vision.",
      );
    }
    isRecording = !isRecording;
    notifyListeners();
  }

  void playRecording() {
    if (entry != null) {
      _audioService.play(entry!.audioPath);
    }
  }
}

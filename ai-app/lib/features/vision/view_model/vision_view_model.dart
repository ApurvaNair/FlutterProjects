import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../model/vision_entry.dart';

class VisionViewModel extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();

  late final RecorderController recorderController;

  bool isRecording = false;
  bool isSpeechAvailable = false;
  String transcript = '';
  String? filePath;
  String? aiResponse;
  VisionEntry? visionData;

  VisionViewModel() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000
      ..bitRate = 64000
      ..checkPermission(); // request mic permission :contentReference[oaicite:5]{index=5}
  }

  Future<void> init() async {
    isSpeechAvailable = await _speech.initialize();
    notifyListeners();
  }

  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    filePath = '${dir.path}/vision_record.m4a';

    await recorderController.record(path: filePath);
    isRecording = true;

    if (isSpeechAvailable) {
      _speech.listen(
        onResult: (res) {
          transcript = res.recognizedWords;
          notifyListeners();
        },
      );
    }

    notifyListeners();
  }

  Future<void> stopRecording() async {
    final path = await recorderController.stop(false);
    filePath = path;
    isRecording = false;

    if (_speech.isListening) await _speech.stop();

    notifyListeners();
    await generateAIResponse();
  }

  Future<void> generateAIResponse() async {
    await Future.delayed(const Duration(seconds: 2));
    aiResponse = "🤖 AI: '$transcript' — that’s an inspiring vision!";
    visionData = VisionEntry(
      audioPath: filePath ?? '',
      transcript: transcript,
      aiResponse: aiResponse!,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VoiceCalculator(),
    );
  }
}

class VoiceCalculator extends StatefulWidget {
  const VoiceCalculator({super.key});

  @override
  _VoiceCalculatorState createState() => _VoiceCalculatorState();
}

class _VoiceCalculatorState extends State<VoiceCalculator> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _result = "Say a calculation";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _result = result.recognizedWords;
            _calculateResult(_result);
          });
        },
        listenFor: const Duration(seconds: 10),
      );
    }
  }

  void _calculateResult(String query) {
    try {
      var result = _evaluateExpression(query);
      _flutterTts.speak("The result is $result");
    } catch (e) {
      _flutterTts.speak("Sorry, I couldn't calculate that.");
    }
  }

  dynamic _evaluateExpression(String expression) {
    try {
      final expressionToEvaluate = Expression.parse(expression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expressionToEvaluate, {});
      return result;
    } catch (e) {
      throw Exception("Invalid expression");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Voice Calculator'),
      ),
      body: Center(
        child: Text(
          _result,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isListening) {
            _speech.stop();
          } else {
            _initializeSpeech();
          }
          setState(() {
            _isListening = !_isListening;
          });
        },
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
    ));
  }
}

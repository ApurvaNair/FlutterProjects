import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_app/feature_box.dart';
import 'package:voice_app/pallette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice App"),
        centerTitle: true,
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/virtualAssistant.png"),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Pallete.borderColor),
                borderRadius: BorderRadius.circular(
                  30,
                ).copyWith(topLeft: Radius.zero),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Good Morning,what task can I do for you?",
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: 25,
                    fontFamily: 'Cera Pro',
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 22),
              child: Text(
                "Here are a few features",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: 'ChatGPT',
                  descriptionText:
                      'A smarter way to stay organized and informed with ChatGPT',
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: 'Dall-E',
                  descriptionText:
                      'Get inspired and stay creative with your personal assistant powered by Dall-E',
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(Icons.mic),
      ),
    );
  }
}

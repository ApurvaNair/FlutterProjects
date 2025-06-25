import 'package:demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Flutter Demo'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.purple,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red,
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.orange,
                ))
          ]),
        ),
      ),
    );
  }
}

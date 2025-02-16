import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
          body: Row(
        children: [
          Image(
              height: 200,
              width: 200,
              image: AssetImage('assets/shipping.jpg')),
          Text('Hi')
        ],
      )),
    );
  }
}

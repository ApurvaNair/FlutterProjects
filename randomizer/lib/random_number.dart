import 'dart:math';
import 'package:flutter/material.dart';

class RandomNumberScreen extends StatelessWidget {
  const RandomNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomNumber = random.nextInt(100); // Random number between 0 and 100
    return Scaffold(
      appBar: AppBar(title: const Text('Random Number')),
      body: Center(child: Text('Random Number: $randomNumber')),
    );
  }
}

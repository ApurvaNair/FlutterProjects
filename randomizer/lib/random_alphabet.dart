import 'package:flutter/material.dart';

class RandomAlphabetScreen extends StatelessWidget {
  const RandomAlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final randomLetter = (letters..shuffle()).first; // Pick a random letter
    return Scaffold(
      appBar: AppBar(title: const Text('Random Alphabet')),
      body: Center(child: Text('Random Alphabet: $randomLetter')),
    );
  }
}

extension on String {
  get first => null;

  shuffle() {}
}

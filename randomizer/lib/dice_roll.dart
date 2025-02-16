import 'dart:math';

import 'package:flutter/material.dart';

class DiceRollScreen extends StatelessWidget {
  const DiceRollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diceRoll = Random().nextInt(6) + 1; // Random dice roll (1-6)
    return Scaffold(
      appBar: AppBar(title: const Text('Dice Roll')),
      body: Center(child: Text('Dice Roll: $diceRoll')),
    );
  }
}

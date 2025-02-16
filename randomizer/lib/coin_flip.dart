import 'dart:math';
import 'package:flutter/material.dart';

class CoinFlipScreen extends StatelessWidget {
  const CoinFlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coinFlip = Random().nextBool() ? 'Heads' : 'Tails';
    return Scaffold(
      appBar: AppBar(title: const Text('Coin Flip')),
      body: Center(child: Text('Coin Flip: $coinFlip')),
    );
  }
}

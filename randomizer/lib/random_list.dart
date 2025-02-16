import 'package:flutter/material.dart';

class RandomListScreen extends StatelessWidget {
  const RandomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
    final randomItem = (list..shuffle()).first; // Random list item
    return Scaffold(
      appBar: AppBar(title: const Text('Random List')),
      body: Center(child: Text('Random Item: $randomItem')),
    );
  }
}

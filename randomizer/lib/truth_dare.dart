import 'package:flutter/material.dart';

class TruthDareScreen extends StatelessWidget {
  const TruthDareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = ['Truth', 'Dare'];
    final choice = (options..shuffle()).first; // Random truth or dare
    return Scaffold(
      appBar: AppBar(title: const Text('Truth or Dare')),
      body: Center(child: Text('Your Choice: $choice')),
    );
  }
}

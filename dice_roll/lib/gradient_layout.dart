import 'package:flutter/material.dart';

class Gradientlayout extends StatelessWidget {
  Gradientlayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.pink, Colors.blue],
              begin: Alignment.topRight,
              end: Alignment.bottomRight),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/dice1.png',
            width: 500,
            height: 200,
          ),
        ));
  }
}

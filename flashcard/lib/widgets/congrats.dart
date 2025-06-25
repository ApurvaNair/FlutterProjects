import 'package:flutter/material.dart';

class CongratsCard extends StatelessWidget {
  final bool allDone;
  final String message;
  final VoidCallback onClose;

  const CongratsCard({
    required this.allDone,
    required this.message,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      left: size.width * 0.09,
      right: size.width * 0.09,
      top: allDone ? 100 : -420,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 12,
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 50),
          child: Column(
            children: [
              Image.asset(
                "assets/congratulations.gif",
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                "Congratulations!",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onClose,
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

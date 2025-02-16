import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const RandomizerApp());
}

class RandomizerApp extends StatelessWidget {
  const RandomizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const RandomizerHome(),
    );
  }
}

class RandomizerHome extends StatelessWidget {
  final List<String> options = [
    'Random Number',
    'Random Alphabet',
    'Dice Roll',
    'Coin Flip',
    'Random List',
    'Truth-Dare'
  ];

  const RandomizerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randomizer!'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _handleOptionClick(context, index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  options[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleOptionClick(BuildContext context, int index) {
    switch (index) {
      case 0:
        _showRandomNumberDialog(context);
        break;
      case 1:
        _showRandomAlphabet(context);
        break;
      case 2:
        _showDiceRoll(context);
        break;
      case 3:
        _showCoinFlip(context);
        break;
      case 4:
        _showRandomList(context);
        break;
      case 5:
        _showTruthDare(context);
        break;
    }
  }

  void _showRandomNumberDialog(BuildContext context) {
    int min = 0;
    int max = 100;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController minController = TextEditingController();
        TextEditingController maxController = TextEditingController();

        return AlertDialog(
          title: const Text('Generate Random Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter Min'),
              ),
              TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter Max'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus(); // Hide keyboard
                int minVal = int.tryParse(minController.text) ?? min;
                int maxVal = int.tryParse(maxController.text) ?? max;

                if (minVal > maxVal) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Min cannot be greater than Max!')),
                  );
                } else {
                  final randomNumber = _generateRandomNumber(minVal, maxVal);
                  Navigator.of(context).pop();
                  _showDialog(
                      context, 'Random Number', randomNumber.toString());
                }
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  int _generateRandomNumber(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void _showRandomAlphabet(BuildContext context) {
    final alphabet =
        String.fromCharCode(65 + (DateTime.now().millisecondsSinceEpoch % 26));
    _showDialog(context, 'Random Alphabet', alphabet);
  }

  void _showDiceRoll(BuildContext context) {
    final diceRoll = (1 + Random().nextInt(6)); // Roll a dice between 1 and 6
    _showDialog(context, 'Dice Roll', diceRoll.toString());
  }

  void _showCoinFlip(BuildContext context) {
    final coinFlip = (Random().nextBool()) ? 'Heads' : 'Tails';
    _showDialog(context, 'Coin Flip', coinFlip);
  }

  void _showRandomList(BuildContext context) {
    final list = ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'];
    final randomItem = list[Random().nextInt(list.length)];
    _showDialog(context, 'Random List Item', randomItem);
  }

  void _showTruthDare(BuildContext context) {
    final options = ['Truth', 'Dare'];
    final randomChoice = options[Random().nextInt(options.length)];
    _showDialog(context, 'Truth or Dare', randomChoice);
  }

  void _showDialog(BuildContext context, String title, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(result),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

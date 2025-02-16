import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Flutter Demo'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.purple,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red,
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.orange,
                ))
          ]),
        ),
      ),
    );
  }
}

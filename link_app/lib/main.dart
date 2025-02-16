import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'link_scanner_screen.dart';

void main() async {
  await dotenv.load();
  runApp(const LinkScannerApp());
}

class LinkScannerApp extends StatelessWidget {
  const LinkScannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Link Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LinkScannerScreen(),
    );
  }
}

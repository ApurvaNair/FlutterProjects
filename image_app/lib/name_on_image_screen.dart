import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class NameOnImageScreen extends StatefulWidget {
  const NameOnImageScreen({super.key});

  @override
  _NameOnImageScreenState createState() => _NameOnImageScreenState();
}

class _NameOnImageScreenState extends State<NameOnImageScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? _backgroundImageBytes;
  bool _isPressed = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    final ByteData data = await rootBundle.load('assets/background.png');
    final ui.Image image = await decodeImageFromList(data.buffer.asUint8List());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      _backgroundImageBytes = byteData?.buffer.asUint8List();
    });
  }

  Future<void> _generateImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    setState(() {
      _showText = true;
    });

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/generated_image.png';
    await File(imagePath).writeAsBytes(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Name on Image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: _globalKey,
                  child: _backgroundImageBytes == null
                      ? const CircularProgressIndicator()
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_backgroundImageBytes != null)
                              Image.memory(
                                _backgroundImageBytes!,
                                fit: BoxFit.cover,
                              ),
                            if (_showText)
                              Center(
                                child: Text(
                                  _controller.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: _generateImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: _isPressed
                        ? [Colors.blueAccent, Colors.lightBlueAccent]
                        : [Colors.blue, Colors.lightBlue],
                  ),
                  boxShadow: _isPressed
                      ? []
                      : [
                          const BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 8.0,
                          ),
                        ],
                ),
                child: const Center(
                  child: Text(
                    'Generate Image',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

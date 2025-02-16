import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkScannerScreen extends StatefulWidget {
  const LinkScannerScreen({Key? key}) : super(key: key);

  @override
  State<LinkScannerScreen> createState() => _LinkScannerScreenState();
}

class _LinkScannerScreenState extends State<LinkScannerScreen> {
  final TextEditingController _linkController = TextEditingController();
  String _resultMessage = "Enter a URL to check for safety.";
  bool _isLoading = false;
  List<String> _communityFeedback = [];

  // Check if the link is malicious using Google Safe Browsing API
  Future<void> scanLink(String url) async {
    setState(() {
      _isLoading = true;
      _resultMessage = "Scanning the link...";
      _communityFeedback = [];
    });

    try {
      final googleApiKey = dotenv.env['GOOGLE_API_KEY']!;
      final googleResponse = await http.post(
        Uri.parse(
            'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$googleApiKey'),
        headers: {"Content-Type": "application/json"},
        body: '''
        {
          "client": {"clientId": "link_app", "clientVersion": "1.0"},
          "threatInfo": {
            "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE"],
            "platformTypes": ["ANY_PLATFORM"],
            "threatEntryTypes": ["URL"],
            "threatEntries": [{"url": "$url"}]
          }
        }
        ''',
      );

      if (googleResponse.statusCode == 200) {
        final googleData = json.decode(googleResponse.body);
        final isMalicious = googleData.containsKey('matches');

        setState(() {
          _resultMessage = isMalicious
              ? "Warning: The link is malicious!"
              : "The link appears safe.";
        });
      } else {
        setState(() {
          _resultMessage = "Error: Failed to scan the link (Google API).";
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = "Error: ${e.toString()}";
      });
    }

    // Fetch Community Feedback
    await fetchCommunityFeedback(url);

    setState(() {
      _isLoading = false;
    });
  }

  // Fetch feedback from Reddit
  Future<void> fetchCommunityFeedback(String url) async {
    try {
      final query = Uri.encodeComponent(url);
      final response = await http.get(
        Uri.parse("https://www.reddit.com/search.json?q=$query"),
        headers: {
          "User-Agent": "LinkSecurityApp/1.0",
          "Authorization": "Bearer ${dotenv.env['REDDIT_ACCESS_TOKEN'] ?? ''}"
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure the expected structure exists before accessing it
        if (data is Map<String, dynamic> &&
            data['data'] is Map<String, dynamic> &&
            data['data']['children'] is List) {
          final children = data['data']['children'] as List;

          // Extract titles safely
          setState(() {
            _communityFeedback = children
                .map((child) {
                  if (child is Map<String, dynamic> &&
                      child['data'] is Map<String, dynamic>) {
                    return child['data']['title'] as String? ??
                        "No title available";
                  }
                  return null;
                })
                .where((title) => title != null)
                .cast<String>()
                .toList();
          });
        } else {
          setState(() {
            _communityFeedback = ["No relevant feedback found."];
          });
        }
      } else {
        setState(() {
          _communityFeedback = [
            "Failed to fetch community feedback. Status: ${response.statusCode}"
          ];
        });
      }
    } catch (e) {
      setState(() {
        _communityFeedback = [
          "Error fetching community feedback: ${e.toString()}"
        ];
      });
    }
  }

  void _openLink(String url) {
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Link Security App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: "Enter URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_linkController.text.isNotEmpty) {
                  scanLink(_linkController.text);
                }
              },
              child: const Text("Scan Link"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                _resultMessage,
                style: TextStyle(
                  color: _resultMessage.contains("Warning")
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Community Feedback:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _communityFeedback.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_communityFeedback[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

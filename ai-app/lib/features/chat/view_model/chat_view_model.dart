import 'package:flutter/material.dart';
import '../model/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void send(String userMsg) {
    _messages.add(
      ChatMessage(sender: "You", message: userMsg, timestamp: DateTime.now()),
    );
    _messages.add(
      ChatMessage(
        sender: "AI",
        message: "AI says: $userMsg",
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

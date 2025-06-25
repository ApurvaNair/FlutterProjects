import 'package:flutter/material.dart';
import '../model/journal_note.dart';

class JournalViewModel extends ChangeNotifier {
  final List<JournalNote> _notes = [];

  List<JournalNote> get notes => _notes;

  void addNote(String content) {
    _notes.add(JournalNote(content: content, date: DateTime.now()));
    notifyListeners();
  }
}

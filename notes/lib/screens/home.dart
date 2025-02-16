import 'dart:math';
import 'dart:async';
import 'package:notes/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/colors.dart';
import 'package:notes/models/note.dart';
import 'package:intl/intl.dart';
import 'package:notes/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Note> sampleNotes = [];
  bool sorted = false;
  List<Note> filteredNotes = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }

  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => b.modifiedTime.compareTo(a.modifiedTime));
    } else {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    }
    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  Future<bool?> confirmDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text(
            'Are you sure you want to delete this note?',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteNote(int index) {
    setState(() {
      sampleNotes.removeAt(index);
      filteredNotes = sampleNotes;
    });
  }

  void toggleSortByModifiedTime() {
    setState(() {
      filteredNotes = sortNotesByModifiedTime(filteredNotes);
      sorted = !sorted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Notes'),
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                sorted
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: Colors.white,
              ),
              onPressed: toggleSortByModifiedTime,
            ),
          ]),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: onSearchTextChanged,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              hintText: "Search notes...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              fillColor: Colors.grey.shade800,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return Card(
                  color: getRandomColor(),
                  child: ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditScreen(note: filteredNotes[index]),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          int originalIndex =
                              sampleNotes.indexOf(filteredNotes[index]);
                          sampleNotes[originalIndex] = Note(
                            id: sampleNotes[originalIndex].id,
                            title: result[0],
                            content: result[1],
                            modifiedTime: DateTime.now(),
                            priority: result[2],
                          );
                          filteredNotes[index] = Note(
                            id: filteredNotes[index].id,
                            title: result[0],
                            content: result[1],
                            modifiedTime: DateTime.now(),
                            priority: result[2],
                          );
                        });
                      }
                    },
                    leading: Icon(
                      Icons.flag,
                      color: getPriorityColor(note.priority),
                    ),
                    title: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: '${note.title} \n',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: note.content,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(note.modifiedTime)}',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final result = await confirmDialog(context);
                        if (result != null && result) {
                          deleteNote(index);
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              Note note = Note(
                id: sampleNotes.length,
                title: result[0],
                content: result[1],
                modifiedTime: DateTime.now(),
                priority: result[2],
              );

              sampleNotes.add(note);
              filteredNotes = sampleNotes;
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

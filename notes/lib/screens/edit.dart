import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String priority = 'Low';

  @override
  void initState() {
    if (widget.note != null) {
      titleController = TextEditingController(text: widget.note!.title);
      contentController = TextEditingController(text: widget.note!.content);
      priority = widget.note!.priority; // Set the priority
    }
    super.initState();
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

  void _openPriorityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.red),
                title: const Text('High'),
                onTap: () {
                  setState(() {
                    priority = 'High';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.orange),
                title: const Text('Medium'),
                onTap: () {
                  setState(() {
                    priority = 'Medium';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.green),
                title: const Text('Low'),
                onTap: () {
                  setState(() {
                    priority = 'Low';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: _openPriorityDialog,
                    icon: Icon(Icons.flag, color: getPriorityColor(priority)),
                  ),
                ],
              ),
              Expanded(
                  child: ListView(
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                  ),
                  TextField(
                    controller: contentController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type something',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                  )
                ],
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(
              context,
              [titleController.text, contentController.text, priority],
            );
          },
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';

class JournalView extends ConsumerWidget {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(journalViewModelProvider);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Journal")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Write your thoughts...",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(journalViewModelProvider.notifier)
                  .addNote(controller.text);
              controller.clear();
            },
            child: const Text("Save Note"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.notes.length,
              itemBuilder: (_, i) {
                final note = viewModel.notes[i];
                return ListTile(
                  title: Text(note.content),
                  subtitle: Text(note.date.toIso8601String()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

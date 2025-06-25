import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';

class RecordVisionView extends ConsumerWidget {
  const RecordVisionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(visionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Record Vision")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () =>
                ref.read(visionViewModelProvider.notifier).toggleRecording(),
            child: Text(
              viewModel.isRecording ? "Stop Recording" : "Start Recording",
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                ref.read(visionViewModelProvider.notifier).playRecording(),
            child: const Text("Play Recording"),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(viewModel.entry?.aiInsight ?? "No insight yet."),
          ),
        ],
      ),
    );
  }
}
